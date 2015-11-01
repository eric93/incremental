#include <cstdio>
#include <cstdlib>
#include <queue>
#include "visits.h"
#include "util.h"


void run_traversals(Tree* root, const Traversal t[], unsigned int num_t) {
    ASSERT(num_t > 0 && t[0].type == TOP_DOWN, "must start with top-down traversal\n");
    std::queue<Tree*> work_queue;

    work_queue.push(root);

    for (int i = 0; i < num_t; i++) {
        std::queue<Tree*> new_queue;
        if (t[i].type == TOP_DOWN) {
            ASSERT(i == 0 || t[i-1].type == BOTTOM_UP, "Invalid traversal sequence");
            
            while (!work_queue.empty()) {
                Tree* n = work_queue.front();
                work_queue.pop();
                ASSERT(n != NULL, "Unexpected empty queue");

                (t[i].visit) (n);

                if (n->num_children == 0) {
                    new_queue.push(n);
                } else {
                    for (int j = 0; j < n->num_children; j++) {
                        work_queue.push(&(n->children[j]));
                    }
                }
                n->children_visited = n->num_children;
            }

        } else if (t[i].type == BOTTOM_UP && !work_queue.empty()) {
            ASSERT(i > 0 && t[i-1].type == TOP_DOWN, "Invalid traversal sequence");

            while(!work_queue.empty()) {
                Tree* n = (Tree*) work_queue.front();
                work_queue.pop();
                ASSERT(n != NULL, "Unexpected empty queue");

                (t[i].visit) (n);

                if (n->parent == NULL) {
                    new_queue.push(n);
                } else {
                    n->parent->children_visited -= 1;
                    if (n->parent->children_visited == 0)
                        work_queue.push(n->parent);
                }
            }
        }

        work_queue = new_queue;
    }
    
}

Tree* generate_tree() {
    InputValue init_val = {0};
    Tree* root = new Tree(NULL,2,NULL,1);

    root->attributes = new_blockflow_attrs(new BlockFlow(
                *(new BaseFlow(0)), 
                rand_inp_length(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                0,
                0,
                rand_inp_length(),
                rand_inp_length(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                true,
                rand_inp_length_auto(),
                0,
                0,
                rand_inp_length()));

    Tree** root_c = new Tree*[2];
    root_c[0] = new Tree(NULL,1,root,2);
    root_c[1] = new Tree(NULL,1,root,3);

    root_c[0]->attributes = new_blockflow_attrs(new BlockFlow(
                *(new BaseFlow(0)), 
                rand_inp_length(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                0,
                0,
                rand_inp_length(),
                rand_inp_length(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                false,
                rand_inp_length_auto(),
                0,
                0,
                rand_inp_length()));

    root_c[1]->attributes = new_blockflow_attrs(new BlockFlow(
                *(new BaseFlow(0)), 
                rand_inp_length(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                0,
                0,
                rand_inp_length(),
                rand_inp_length(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                false,
                rand_inp_length_auto(),
                0,
                0,
                rand_inp_length()));
                
    root->children = root_c[0];

    Tree* leaf1 = new Tree(NULL,0,root_c[0],4); 
    Tree* leaf2 = new Tree(NULL,0,root_c[1],5);

    leaf1->attributes = new_blockflow_attrs(new BlockFlow(
                *(new BaseFlow(0)), 
                rand_inp_length(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                0,
                0,
                rand_inp_length(),
                rand_inp_length(),
                rand_inp_length_auto(),
                rand_inp_length_auto(),
                false,
                rand_inp_length_auto(),
                0,
                0,
                rand_inp_length()));

    leaf2->attributes = new_blockflow_attrs(new BlockFlow(
                *(new BaseFlow(0)), 
                rand_inp_length(),
                rand_inp_length(),
                rand_inp_length(),
                rand_inp_length(),
                0,
                0,
                rand_inp_length(),
                rand_inp_length(),
                rand_inp_length(),
                rand_inp_length(),
                false,
                rand_inp_length(),
                0,
                0,
                rand_inp_length()));


    root_c[0]->children = leaf1;
    root_c[1]->children = leaf2;

    return root;
}

void print_num(Tree* t) {
    printf("Node: %d\n", t->num);
}

int main() {
    Traversal t0 = {TOP_DOWN, print_num};
    Traversal t1 = {BOTTOM_UP, print_num};
    Traversal tr[2] = {t0,t1};


    run_traversals(generate_tree(),traversal_sequence,4);
    return 0;
}
