#ifndef __VISITS_H__
#define __VISITS_H__
#include "util.h"
#include "fields.h"

void visit_0(Tree* node);
void visit_1(Tree* node);
void visit_2(Tree* node);
void visit_3(Tree* node);


const static Traversal t0 = {TOP_DOWN, visit_0};
const static Traversal t1 = {BOTTOM_UP, visit_1};
const static Traversal t2 = {TOP_DOWN, visit_2};
const static Traversal t3 = {BOTTOM_UP, visit_3};
const static Traversal traversal_sequence[4] = {t0,t1,t2,t3};

BaseFlow* get_baseflow_child(Tree* child);
InlineBox* get_inlinebox_child(Tree* child);

#endif
