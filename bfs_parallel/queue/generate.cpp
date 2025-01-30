#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

// R-MAT parameters (*100)
#if 1
// Scale-free, small-world graph
#define A 57
#define B 19
#define C 19
#define D 5
#else
// Erdos-Renyi, uniform random graph
// For reference. Do not use.
#define A 25
#define B 25
#define C 25
#define D 25
#endif

#include "bfs.hpp"

int main(int argc, char** argv)
{
   struct bench_args_t data;
   int fd;
   node_index_t* adjmat;
   node_index_t r, c, s, temp;
   edge_index_t e;
   int scale;
   long int rint;
   struct prng_rand_t state;

   // Generate dense R-MAT matrix
   adjmat = (node_index_t*)calloc(N_NODES * N_NODES, sizeof(node_index_t));
   prng_srand(1, &state);

   e = 0;
   while(e < N_EDGES / 2)
   { // generate N_EDGES/2 undirected edges (N_EDGES directed)
      r = 0;
      c = 0;
      // Pick a random edge according to R-MAT parameters
      for(scale = SCALE; scale > 0; scale--)
      { // each level of the quadtree
         rint = prng_rand(&state) % 100;
         if(rint >= (A + B)) // C or D (bottom half)
            r += 1 << (scale - 1);
         if((rint >= A && rint < A + B) || (rint >= A + B + C)) // B or D (right half)
            c += 1 << (scale - 1);
      }
      if(adjmat[r * N_NODES + c] == 0 && r != c)
      { // ignore self-edges, they're irrelevant
         // We make undirected edges
         adjmat[r * N_NODES + c] = 1;
         adjmat[c * N_NODES + r] = 1;
         ++e;
      }
   }

   // Shuffle matrix (to eliminate degree locality)
   for(s = 0; s < N_NODES; s++)
   {
      rint = prng_rand(&state) % N_NODES;
      // Swap row s with row rint
      for(c = 0; c < N_NODES; c++)
      {
         temp = adjmat[s * N_NODES + c];
         adjmat[s * N_NODES + c] = adjmat[rint * N_NODES + c];
         adjmat[rint * N_NODES + c] = temp;
      }
      // Swap col s with col rint (to keep symmetry)
      for(r = 0; r < N_NODES; r++)
      {
         temp = adjmat[r * N_NODES + s];
         adjmat[r * N_NODES + s] = adjmat[r * N_NODES + rint];
         adjmat[r * N_NODES + rint] = temp;
      }
   }

   // Scan rows for edge list lengths, and fill edges while we're at it
   e = 0;
   for(r = 0; r < N_NODES; r++)
   { // count first
      data.nodes[r].edge_begin = 0;
      data.nodes[r].edge_end = 0;
      for(c = 0; c < N_NODES; c++)
      {
         if(adjmat[r * N_NODES + c])
         {
            ++data.nodes[r].edge_end;
            data.edges[e].dst = c;
            // data.edges[e].weight = prng_rand(&state)%(MAX_WEIGHT-MIN_WEIGHT)+MIN_WEIGHT;
            ++e;
         }
      }
   }

   for(r = 1; r < N_NODES; r++)
   { // now scan
      data.nodes[r].edge_begin = data.nodes[r - 1].edge_end;
      data.nodes[r].edge_end += data.nodes[r - 1].edge_end;
   }

   // Pick starting node
   do
   {
      rint = prng_rand(&state) % N_NODES;
   } while((data.nodes[rint].edge_end - data.nodes[rint].edge_begin) < 2);
   data.starting_node = rint;

   // Open and write
   fd = open("input.data", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);
   assert(fd > 0 && "Couldn't open input data file");
   data_to_input(fd, &data);
   free(adjmat);

   return 0;
}
