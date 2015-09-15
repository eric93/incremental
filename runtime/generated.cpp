
#include <cstdio>
#include "generated.h"
#include "visits.h"
//@type action
int inlineflow_flowX ( int _ale_arg0) { return _ale_arg0; }
//@type action
int inlineflow_totalWidth ( int _ale_arg0) { return _ale_arg0; }
//@type action
int inlineflow_flowY ( int _ale_arg0) { return _ale_arg0; }
//@type action
int inlineflow_totalHeight ( int _ale_arg0) { return _ale_arg0; }
//@type action
int inlineflow_flowWidth ( int _ale_arg0) { return _ale_arg0; }
//@type action
int blockflow_ml ( int _ale_arg3,  InputLength _ale_arg1,  InputLength _ale_arg0,  int _ale_arg6,  InputLength _ale_arg2,  int _ale_arg5,  int _ale_arg8,  int _ale_arg7,  int _ale_arg4) { return (is_auto(_ale_arg0)) ? ( ((is_auto(_ale_arg1)) ? ( 0 ) : ( ((is_auto(_ale_arg2)) ? ( (_ale_arg3 - _ale_arg4 - _ale_arg5 - _ale_arg6 - _ale_arg7 - _ale_arg8) / 2 ) : ( (_ale_arg3 - _ale_arg4 - _ale_arg5 - _ale_arg6 - _ale_arg7 - _ale_arg8 - spec_or_zero(_ale_arg2, _ale_arg3)) )) )) ) : ( spec_or_zero(_ale_arg0, _ale_arg3) ); }
//@type action
int blockflow_pb ( int _ale_arg1,  InputLength _ale_arg0) { return specified(_ale_arg0, _ale_arg1); }
//@type action
int blockflow_bb ( int _ale_arg0) { return _ale_arg0; }
//@type action
int blockflow_mbpVert ( int _ale_arg3,  int _ale_arg0,  int _ale_arg1,  int _ale_arg2,  int _ale_arg5,  int _ale_arg4) { return _ale_arg0 + _ale_arg1 + _ale_arg2 + _ale_arg3 + _ale_arg4 + _ale_arg5; }
//@type action
int blockflow_computedWidth ( bool _ale_arg0,  int _ale_arg3,  InputLength _ale_arg2,  int _ale_arg4,  int _ale_arg5,  int _ale_arg1) { return (_ale_arg0) ? ( _ale_arg1 ) : ( ((is_auto(_ale_arg2)) ? ( _ale_arg3 - _ale_arg4 ) : ( _ale_arg5 )) ); }
//@type action
int blockflow_flowX ( int _ale_arg0,  int _ale_arg1) { return _ale_arg0 + _ale_arg1; }
//@type action
int blockflow_mbpHoriz ( int _ale_arg1,  int _ale_arg4,  int _ale_arg2,  int _ale_arg5,  int _ale_arg0,  int _ale_arg3) { return _ale_arg0 + _ale_arg1 + _ale_arg2 + _ale_arg3 + _ale_arg4 + _ale_arg5; }
//@type action
int blockflow_mr ( int _ale_arg3,  InputLength _ale_arg2,  InputLength _ale_arg1,  int _ale_arg7,  InputLength _ale_arg0,  int _ale_arg5,  int _ale_arg8,  int _ale_arg6,  int _ale_arg4) { return ((((! is_auto(_ale_arg0)) && ((is_auto(_ale_arg1) || is_auto(_ale_arg2)))))) ? ( spec_or_zero(_ale_arg0, _ale_arg3) ) : ( ((is_auto(_ale_arg1)) ? ( 0 ) : ( ((is_auto(_ale_arg2)) ? ( (_ale_arg3 - _ale_arg4 - _ale_arg5 - _ale_arg6 - _ale_arg7 - _ale_arg8) / 2 ) : ( (_ale_arg3 - _ale_arg4 - _ale_arg5 - _ale_arg6 - _ale_arg7 - _ale_arg8 - spec_or_zero(_ale_arg2, _ale_arg3)) )) )) ); }
//@type action
int blockflow_mb ( InputLength _ale_arg0,  int _ale_arg1) { return (is_auto(_ale_arg0)) ? ( 0 ) : ( spec_or_zero(_ale_arg0, _ale_arg1) ); }
//@type action
int blockflow_pr ( int _ale_arg1,  InputLength _ale_arg0) { return specified(_ale_arg0, _ale_arg1); }
//@type action
DisplayList blockflow_makeList ( int _ale_arg5,  int _ale_arg4,  int _ale_arg9,  int _ale_arg3,  int _ale_arg2,  int _ale_arg0,  int _ale_arg8,  int _ale_arg7,  int _ale_arg1,  int _ale_arg6) { return add_border(add_background(new_display_list(), _ale_arg0 + _ale_arg1, _ale_arg2 + _ale_arg3, _ale_arg4, _ale_arg5), _ale_arg0 + _ale_arg1, _ale_arg2 + _ale_arg3, _ale_arg4, _ale_arg5, _ale_arg6, _ale_arg7, _ale_arg8, _ale_arg9); }
//@type action
int blockflow_flowHeight ( int _ale_arg2,  int _ale_arg1,  int _ale_arg3,  int _ale_arg0,  int _ale_arg4,  int _ale_arg5) { return ((_ale_arg0 == 0)) ? ( _ale_arg1 + _ale_arg2 + _ale_arg3 + _ale_arg4 + _ale_arg5 ) : ( _ale_arg0 + _ale_arg2 + _ale_arg3 + _ale_arg4 + _ale_arg5 ); }
//@type action
int blockflow_totalHeight ( int _ale_arg0,  int _ale_arg1,  int _ale_arg2) { return _ale_arg0 + _ale_arg1 + _ale_arg2; }
//@type action
int blockflow_selfIntrinsHeight ( InputLength _ale_arg0) { return spec_or_zero(_ale_arg0, 0); }
//@type action
int blockflow_pt ( int _ale_arg1,  InputLength _ale_arg0) { return specified(_ale_arg0, _ale_arg1); }
//@type action
int blockflow_pl ( int _ale_arg1,  InputLength _ale_arg0) { return specified(_ale_arg0, _ale_arg1); }
//@type action
int blockflow_flowY ( int _ale_arg0,  int _ale_arg1) { return _ale_arg0 + _ale_arg1; }
//@type action
int blockflow_flowWidth ( bool _ale_arg0,  int _ale_arg5,  int _ale_arg3,  int _ale_arg2,  int _ale_arg6,  int _ale_arg1,  int _ale_arg4) { return (_ale_arg0) ? ( _ale_arg1 ) : ( _ale_arg2 + _ale_arg3 + _ale_arg4 + _ale_arg5 + _ale_arg6 ); }
//@type action
int blockflow_totalWidth ( int _ale_arg0,  int _ale_arg2,  int _ale_arg1) { return _ale_arg0 + _ale_arg1 + _ale_arg2; }
//@type action
int blockflow_bt ( int _ale_arg0) { return _ale_arg0; }
//@type action
int blockflow_mt ( int _ale_arg1,  InputLength _ale_arg0) { return (is_auto(_ale_arg0)) ? ( 0 ) : ( spec_or_zero(_ale_arg0, _ale_arg1) ); }
//@type action
int blockflow_bl ( int _ale_arg0) { return _ale_arg0; }
//@type action
int blockflow_selfIntrinsWidth ( int _ale_arg1,  InputLength _ale_arg0) { return spec_or_zero(_ale_arg0, _ale_arg1); }
//@type action
int blockflow_br ( int _ale_arg0) { return _ale_arg0; }
 void visit_blockflow_0(BlockFlow* self, Tree* children, unsigned int num_children) {
  printf("FTL:   visit  BlockFlow %s\n", "0");
  self->bb = (blockflow_bb(self->borderbottom));
  printf("FTL:     blockflow_bb %s\n", to_string(self->bb));
  printf("FTL:         borderBottom %s\n", to_string(self->borderbottom));
  self->bl = (blockflow_bl(self->borderleft));
  printf("FTL:     blockflow_bl %s\n", to_string(self->bl));
  printf("FTL:         borderLeft %s\n", to_string(self->borderleft));
  self->br = (blockflow_br(self->borderright));
  printf("FTL:     blockflow_br %s\n", to_string(self->br));
  printf("FTL:         borderRight %s\n", to_string(self->borderright));
  self->bt = (blockflow_bt(self->bordertop));
  printf("FTL:     blockflow_bt %s\n", to_string(self->bt));
  printf("FTL:         borderTop %s\n", to_string(self->bordertop));
  self->mb = (blockflow_mb(self->marginbottom, self->base.availablewidth));
  printf("FTL:     blockflow_mb %s\n", to_string(self->mb));
  printf("FTL:         marginBottom %s\n", to_string(self->marginbottom));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  self->mt = (blockflow_mt(self->base.availablewidth, self->margintop));
  printf("FTL:     blockflow_mt %s\n", to_string(self->mt));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  printf("FTL:         marginTop %s\n", to_string(self->margintop));
  self->pb = (blockflow_pb(self->base.availablewidth, self->paddingbottom));
  printf("FTL:     blockflow_pb %s\n", to_string(self->pb));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  printf("FTL:         paddingBottom %s\n", to_string(self->paddingbottom));
  self->pl = (blockflow_pl(self->base.availablewidth, self->paddingleft));
  printf("FTL:     blockflow_pl %s\n", to_string(self->pl));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  printf("FTL:         paddingLeft %s\n", to_string(self->paddingleft));
  self->pr = (blockflow_pr(self->base.availablewidth, self->paddingright));
  printf("FTL:     blockflow_pr %s\n", to_string(self->pr));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  printf("FTL:         paddingRight %s\n", to_string(self->paddingright));
  self->pt = (blockflow_pt(self->base.availablewidth, self->paddingtop));
  printf("FTL:     blockflow_pt %s\n", to_string(self->pt));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  printf("FTL:         paddingTop %s\n", to_string(self->paddingtop));
  self->selfintrinsheight = (blockflow_selfIntrinsHeight(self->boxstyleheight));
  printf("FTL:     blockflow_selfIntrinsHeight %s\n", to_string(self->selfintrinsheight));
  printf("FTL:         boxStyleHeight %s\n", to_string(self->boxstyleheight));
  self->selfintrinswidth = (blockflow_selfIntrinsWidth(self->base.availablewidth, self->boxstylewidth));
  printf("FTL:     blockflow_selfIntrinsWidth %s\n", to_string(self->selfintrinswidth));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  printf("FTL:         boxStyleWidth %s\n", to_string(self->boxstylewidth));
  self->mbpvert = (blockflow_mbpVert(self->pb, self->mt, self->mb, self->pt, self->bb, self->bt));
  printf("FTL:     blockflow_mbpVert %s\n", to_string(self->mbpvert));
  printf("FTL:         pb %s\n", to_string(self->pb));
  printf("FTL:         mt %s\n", to_string(self->mt));
  printf("FTL:         mb %s\n", to_string(self->mb));
  printf("FTL:         pt %s\n", to_string(self->pt));
  printf("FTL:         bb %s\n", to_string(self->bb));
  printf("FTL:         bt %s\n", to_string(self->bt));
  self->ml = (blockflow_ml(self->base.availablewidth, self->boxstylewidth, self->marginleft, self->bl, self->marginright, self->pl, self->selfintrinswidth, self->br, self->pr));
  printf("FTL:     blockflow_ml %s\n", to_string(self->ml));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  printf("FTL:         boxStyleWidth %s\n", to_string(self->boxstylewidth));
  printf("FTL:         marginLeft %s\n", to_string(self->marginleft));
  printf("FTL:         bl %s\n", to_string(self->bl));
  printf("FTL:         marginRight %s\n", to_string(self->marginright));
  printf("FTL:         pl %s\n", to_string(self->pl));
  printf("FTL:         selfIntrinsWidth %s\n", to_string(self->selfintrinswidth));
  printf("FTL:         br %s\n", to_string(self->br));
  printf("FTL:         pr %s\n", to_string(self->pr));
  self->mr = (blockflow_mr(self->base.availablewidth, self->marginleft, self->boxstylewidth, self->bl, self->marginright, self->pl, self->selfintrinswidth, self->br, self->pr));
  printf("FTL:     blockflow_mr %s\n", to_string(self->mr));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  printf("FTL:         marginLeft %s\n", to_string(self->marginleft));
  printf("FTL:         boxStyleWidth %s\n", to_string(self->boxstylewidth));
  printf("FTL:         bl %s\n", to_string(self->bl));
  printf("FTL:         marginRight %s\n", to_string(self->marginright));
  printf("FTL:         pl %s\n", to_string(self->pl));
  printf("FTL:         selfIntrinsWidth %s\n", to_string(self->selfintrinswidth));
  printf("FTL:         br %s\n", to_string(self->br));
  printf("FTL:         pr %s\n", to_string(self->pr));
  self->mbphoriz = (blockflow_mbpHoriz(self->mr, self->bl, self->pl, self->br, self->ml, self->pr));
  printf("FTL:     blockflow_mbpHoriz %s\n", to_string(self->mbphoriz));
  printf("FTL:         mr %s\n", to_string(self->mr));
  printf("FTL:         bl %s\n", to_string(self->bl));
  printf("FTL:         pl %s\n", to_string(self->pl));
  printf("FTL:         br %s\n", to_string(self->br));
  printf("FTL:         ml %s\n", to_string(self->ml));
  printf("FTL:         pr %s\n", to_string(self->pr));
  self->computedwidth = (blockflow_computedWidth(self->is_root, self->base.availablewidth, self->boxstylewidth, self->mbphoriz, self->selfintrinswidth, self->base.screenwidth));
  printf("FTL:     blockflow_computedWidth %s\n", to_string(self->computedwidth));
  printf("FTL:         is_root %s\n", to_string(self->is_root));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  printf("FTL:         boxStyleWidth %s\n", to_string(self->boxstylewidth));
  printf("FTL:         mbpHoriz %s\n", to_string(self->mbphoriz));
  printf("FTL:         selfIntrinsWidth %s\n", to_string(self->selfintrinswidth));
  printf("FTL:         screenwidth %s\n", to_string(self->base.screenwidth));
  self->base.flowwidth = (blockflow_flowWidth(self->is_root, self->bl, self->pl, self->computedwidth, self->br, self->base.screenwidth, self->pr));
  printf("FTL:     blockflow_flowWidth %s\n", to_string(self->base.flowwidth));
  printf("FTL:         is_root %s\n", to_string(self->is_root));
  printf("FTL:         bl %s\n", to_string(self->bl));
  printf("FTL:         pl %s\n", to_string(self->pl));
  printf("FTL:         computedWidth %s\n", to_string(self->computedwidth));
  printf("FTL:         br %s\n", to_string(self->br));
  printf("FTL:         screenwidth %s\n", to_string(self->base.screenwidth));
  printf("FTL:         pr %s\n", to_string(self->pr));
  self->base.totalwidth = (blockflow_totalWidth(self->base.flowwidth, self->mr, self->ml));
  printf("FTL:     blockflow_totalWidth %s\n", to_string(self->base.totalwidth));
  printf("FTL:         flowWidth %s\n", to_string(self->base.flowwidth));
  printf("FTL:         mr %s\n", to_string(self->mr));
  printf("FTL:         ml %s\n", to_string(self->ml));

  self->childs_availablewidth_init = ((0));
  self->childs_availablewidth_last = (self->childs_availablewidth_init);
  printf("FTL:       init childs@availableWidth %s\n", to_string(self->childs_availablewidth_init));
  printf("FTL:     last init childs_availablewidth_last %s\n", to_string(self->childs_availablewidth_last));
  {
  BaseFlow* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    BaseFlow* child = get_baseflow_child(children+i);
      child->availablewidth = ((self->computedwidth ));
      self->childs_availablewidth_last = child->availablewidth;
      printf("FTL:          step childs@availableWidth %s\n", to_string(child->availablewidth));
    old_child = child;
  }
}

 
 }
 void visit_blockflow_1(BlockFlow* self, Tree* children, unsigned int num_children) {
  printf("FTL:   visit  BlockFlow %s\n", "1");

{
  BaseFlow* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    BaseFlow* child = get_baseflow_child(children+i);
    old_child = child;
  }
}


  self->childs_bottom_init = ((self->pt + self->bt ));
  self->childs_bottom_last = (self->childs_bottom_init);
  printf("FTL:       init childs@bottom %s\n", to_string(self->childs_bottom_init));
  printf("FTL:     last init childs_bottom_last %s\n", to_string(self->childs_bottom_last));
    self->childs_right_init = ((0));
  self->childs_right_last = (self->childs_right_init);
  printf("FTL:       init childs@right %s\n", to_string(self->childs_right_init));
  printf("FTL:     last init childs_right_last %s\n", to_string(self->childs_right_last));
    self->childsheight_init = ((0));
  self->childsheight = (self->childsheight_init);
  printf("FTL:       init childsHeight %s\n", to_string(self->childsheight_init));
  printf("FTL:     last init childsheight %s\n", to_string(self->childsheight));
    self->childswidth_init = ((0));
  self->childswidth = (self->childswidth_init);
  printf("FTL:       init childsWidth %s\n", to_string(self->childswidth_init));
  printf("FTL:     last init childswidth %s\n", to_string(self->childswidth));
  {
  BaseFlow* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    BaseFlow* child = get_baseflow_child(children+i);
      child->bottom = (((((i == 0) ? ( self->childs_bottom_init ) : (  old_child->bottom )) + child->totalheight)));
      self->childs_bottom_last = child->bottom;
      printf("FTL:          step childs@bottom %s\n", to_string(child->bottom));
      child->right = (((child->totalwidth + self->pl + self->bl)));
      self->childs_right_last = child->right;
      printf("FTL:          step childs@right %s\n", to_string(child->right));
      self->childsheight = (((self->childsheight + child->totalheight)));
      printf("FTL:          step childsHeight %s\n", to_string(self->childsheight));
      self->childswidth = ((max(self->childswidth, child->totalwidth)));
      printf("FTL:          step childsWidth %s\n", to_string(self->childswidth));
    old_child = child;
  }
}


  self->childs_containingx_init = ((0));
  self->childs_containingx_last = (self->childs_containingx_init);
  printf("FTL:       init childs@containingX %s\n", to_string(self->childs_containingx_init));
  printf("FTL:     last init childs_containingx_last %s\n", to_string(self->childs_containingx_last));
    self->childs_containingy_init = ((0));
  self->childs_containingy_last = (self->childs_containingy_init);
  printf("FTL:       init childs@containingY %s\n", to_string(self->childs_containingy_init));
  printf("FTL:     last init childs_containingy_last %s\n", to_string(self->childs_containingy_last));
  {
  BaseFlow* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    BaseFlow* child = get_baseflow_child(children+i);
      child->containingx = ((child->right - child->totalwidth ));
      self->childs_containingx_last = child->containingx;
      printf("FTL:          step childs@containingX %s\n", to_string(child->containingx));
      child->containingy = ((child->bottom - child->totalheight ));
      self->childs_containingy_last = child->containingy;
      printf("FTL:          step childs@containingY %s\n", to_string(child->containingy));
    old_child = child;
  }
}

  self->base.flowheight = (blockflow_flowHeight(self->pb, self->childsheight, self->pt, self->selfintrinsheight, self->bb, self->bt));
  printf("FTL:     blockflow_flowHeight %s\n", to_string(self->base.flowheight));
  printf("FTL:         pb %s\n", to_string(self->pb));
  printf("FTL:         childsHeight %s\n", to_string(self->childsheight));
  printf("FTL:         pt %s\n", to_string(self->pt));
  printf("FTL:         selfIntrinsHeight %s\n", to_string(self->selfintrinsheight));
  printf("FTL:         bb %s\n", to_string(self->bb));
  printf("FTL:         bt %s\n", to_string(self->bt));
  self->base.totalheight = (blockflow_totalHeight(self->base.flowheight, self->mt, self->mb));
  printf("FTL:     blockflow_totalHeight %s\n", to_string(self->base.totalheight));
  printf("FTL:         flowHeight %s\n", to_string(self->base.flowheight));
  printf("FTL:         mt %s\n", to_string(self->mt));
  printf("FTL:         mb %s\n", to_string(self->mb));
 
 }
 void visit_blockflow_2(BlockFlow* self, Tree* children, unsigned int num_children) {
  printf("FTL:   visit  BlockFlow %s\n", "2");
  self->base.flowx = (blockflow_flowX(self->base.containingx, self->ml));
  printf("FTL:     blockflow_flowX %s\n", to_string(self->base.flowx));
  printf("FTL:         containingX %s\n", to_string(self->base.containingx));
  printf("FTL:         ml %s\n", to_string(self->ml));
  self->base.flowy = (blockflow_flowY(self->base.containingy, self->mt));
  printf("FTL:     blockflow_flowY %s\n", to_string(self->base.flowy));
  printf("FTL:         containingY %s\n", to_string(self->base.containingy));
  printf("FTL:         mt %s\n", to_string(self->mt));
  self->base.makelist = (blockflow_makeList(self->base.flowheight, self->base.flowwidth, self->bl, self->mt, self->base.absy, self->base.absx, self->bb, self->br, self->ml, self->bt));
  printf("FTL:     blockflow_makeList %s\n", to_string(self->base.makelist));
  printf("FTL:         flowHeight %s\n", to_string(self->base.flowheight));
  printf("FTL:         flowWidth %s\n", to_string(self->base.flowwidth));
  printf("FTL:         bl %s\n", to_string(self->bl));
  printf("FTL:         mt %s\n", to_string(self->mt));
  printf("FTL:         absY %s\n", to_string(self->base.absy));
  printf("FTL:         absX %s\n", to_string(self->base.absx));
  printf("FTL:         bb %s\n", to_string(self->bb));
  printf("FTL:         br %s\n", to_string(self->br));
  printf("FTL:         ml %s\n", to_string(self->ml));
  printf("FTL:         bt %s\n", to_string(self->bt));

  self->childs_absx_init = ((0));
  self->childs_absx_last = (self->childs_absx_init);
  printf("FTL:       init childs@absX %s\n", to_string(self->childs_absx_init));
  printf("FTL:     last init childs_absx_last %s\n", to_string(self->childs_absx_last));
    self->childs_absy_init = ((0));
  self->childs_absy_last = (self->childs_absy_init);
  printf("FTL:       init childs@absY %s\n", to_string(self->childs_absy_init));
  printf("FTL:     last init childs_absy_last %s\n", to_string(self->childs_absy_last));
  {
  BaseFlow* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    BaseFlow* child = get_baseflow_child(children+i);
      child->absx = ((child->containingx + self->base.absx + self->ml ));
      self->childs_absx_last = child->absx;
      printf("FTL:          step childs@absX %s\n", to_string(child->absx));
      child->absy = ((child->containingy + self->base.absy + self->mt ));
      self->childs_absy_last = child->absy;
      printf("FTL:          step childs@absY %s\n", to_string(child->absy));
    old_child = child;
  }
}

 
 }
 void visit_blockflow_3(BlockFlow* self, Tree* children, unsigned int num_children) {
  printf("FTL:   visit  BlockFlow %s\n", "3");

{
  BaseFlow* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    BaseFlow* child = get_baseflow_child(children+i);
    old_child = child;
  }
}


  self->display_list_init = ((self->base.makelist ));
  self->base.display_list = (self->display_list_init);
  printf("FTL:       init display_list %s\n", to_string(self->display_list_init));
  printf("FTL:     last init display_list %s\n", to_string(self->base.display_list));
  {
  BaseFlow* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    BaseFlow* child = get_baseflow_child(children+i);
      self->base.display_list = ((merge_lists(self->base.display_list, child->display_list)));
      printf("FTL:          step display_list %s\n", to_string(self->base.display_list));
    old_child = child;
  }
}

 
 }
 void visit_inlineflow_0(InlineFlow* self, Tree* children, unsigned int num_children) {
  printf("FTL:   visit  InlineFlow %s\n", "0");
  self->base.flowwidth = (inlineflow_flowWidth(self->base.availablewidth));
  printf("FTL:     inlineflow_flowWidth %s\n", to_string(self->base.flowwidth));
  printf("FTL:         availableWidth %s\n", to_string(self->base.availablewidth));
  self->base.totalwidth = (inlineflow_totalWidth(self->base.flowwidth));
  printf("FTL:     inlineflow_totalWidth %s\n", to_string(self->base.totalwidth));
  printf("FTL:         flowWidth %s\n", to_string(self->base.flowwidth));

{
  InlineBox* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    InlineBox* child = get_inlinebox_child(children+i);
    old_child = child;
  }
}


  self->childs_baseline_init = ((0));
  self->childs_baseline_last = (self->childs_baseline_init);
  printf("FTL:       init childs@baseline %s\n", to_string(self->childs_baseline_init));
  printf("FTL:     last init childs_baseline_last %s\n", to_string(self->childs_baseline_last));
    self->childs_endofline_init = ((true));
  self->childs_endofline_last = (self->childs_endofline_init);
  printf("FTL:       init childs@endOfLine %s\n", to_string(self->childs_endofline_init));
  printf("FTL:     last init childs_endofline_last %s\n", to_string(self->childs_endofline_last));
    self->childs_availabletextwidth_init = ((self->base.availablewidth ));
  self->childs_availabletextwidth_last = (self->childs_availabletextwidth_init);
  printf("FTL:       init childs@availableTextWidth %s\n", to_string(self->childs_availabletextwidth_init));
  printf("FTL:     last init childs_availabletextwidth_last %s\n", to_string(self->childs_availabletextwidth_last));
  {
  InlineBox* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    InlineBox* child = get_inlinebox_child(children+i);
      child->baseline = (((((i == 0) ? ( self->childs_endofline_init ) : (  old_child->endofline ))) ? ( child->inlineascent ) : ( max(((i == 0) ? ( self->childs_baseline_init ) : (  old_child->baseline )), child->inlineascent) )));
      self->childs_baseline_last = child->baseline;
      printf("FTL:          step childs@baseline %s\n", to_string(child->baseline));
      child->endofline = ((((child->inlinewidth > ((i == 0) ? ( self->childs_availabletextwidth_init ) : (  old_child->availabletextwidth ))) || child->mustendline)));
      self->childs_endofline_last = child->endofline;
      printf("FTL:          step childs@endOfLine %s\n", to_string(child->endofline));
      child->availabletextwidth = ((((child->endofline)) ? ( (self->base.availablewidth) ) : ( (((i == 0) ? ( self->childs_availabletextwidth_init ) : (  old_child->availabletextwidth )) - child->inlinewidth) )));
      self->childs_availabletextwidth_last = child->availabletextwidth;
      printf("FTL:          step childs@availableTextWidth %s\n", to_string(child->availabletextwidth));
    old_child = child;
  }
}


  self->childs_baselinefinal_init = ((0));
  self->childs_baselinefinal_last = (self->childs_baselinefinal_init);
  printf("FTL:       init childs@baselineFinal %s\n", to_string(self->childs_baselinefinal_init));
  printf("FTL:     last init childs_baselinefinal_last %s\n", to_string(self->childs_baselinefinal_last));
  {
  InlineBox* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    InlineBox* child = get_inlinebox_child(children+i);
      child->baselinefinal = (((((i == 0) ? ( self->childs_endofline_init ) : (  old_child->endofline ))) ? ( child->baseline ) : ( ((i == 0) ? ( self->childs_baselinefinal_init ) : (  old_child->baselinefinal )) )));
      self->childs_baselinefinal_last = child->baselinefinal;
      printf("FTL:          step childs@baselineFinal %s\n", to_string(child->baselinefinal));
    old_child = child;
  }
}


  self->childs_lineheight_init = ((0));
  self->childs_lineheight_last = (self->childs_lineheight_init);
  printf("FTL:       init childs@lineHeight %s\n", to_string(self->childs_lineheight_init));
  printf("FTL:     last init childs_lineheight_last %s\n", to_string(self->childs_lineheight_last));
    self->childs_lineposy_init = ((0));
  self->childs_lineposy_last = (self->childs_lineposy_init);
  printf("FTL:       init childs@linePosY %s\n", to_string(self->childs_lineposy_init));
  printf("FTL:     last init childs_lineposy_last %s\n", to_string(self->childs_lineposy_last));
    self->childs_right_init = ((0));
  self->childs_right_last = (self->childs_right_init);
  printf("FTL:       init childs@right %s\n", to_string(self->childs_right_init));
  printf("FTL:     last init childs_right_last %s\n", to_string(self->childs_right_last));
  {
  InlineBox* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    InlineBox* child = get_inlinebox_child(children+i);
      child->lineheight = (((((i == 0) ? ( self->childs_endofline_init ) : (  old_child->endofline ))) ? ( child->inlineheight ) : ( max(((i == 0) ? ( self->childs_lineheight_init ) : (  old_child->lineheight )), child->inlineheight) )));
      self->childs_lineheight_last = child->lineheight;
      printf("FTL:          step childs@lineHeight %s\n", to_string(child->lineheight));
      child->lineposy = (((((i == 0) ? ( self->childs_endofline_init ) : (  old_child->endofline ))) ? ( (((i == 0) ? ( self->childs_lineposy_init ) : (  old_child->lineposy )) + ((i == 0) ? ( self->childs_lineheight_init ) : (  old_child->lineheight ))) ) : ( ((i == 0) ? ( self->childs_lineposy_init ) : (  old_child->lineposy )) )));
      self->childs_lineposy_last = child->lineposy;
      printf("FTL:          step childs@linePosY %s\n", to_string(child->lineposy));
      child->right = (((((i == 0) ? ( self->childs_endofline_init ) : (  old_child->endofline ))) ? ( child->inlinewidth ) : ( ((i == 0) ? ( self->childs_right_init ) : (  old_child->right )) + child->inlinewidth )));
      self->childs_right_last = child->right;
      printf("FTL:          step childs@right %s\n", to_string(child->right));
    old_child = child;
  }
}


  self->flowheight_init = ((0));
  self->base.flowheight = (self->flowheight_init);
  printf("FTL:       init flowHeight %s\n", to_string(self->flowheight_init));
  printf("FTL:     last init flowheight %s\n", to_string(self->base.flowheight));
  {
  InlineBox* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    InlineBox* child = get_inlinebox_child(children+i);
      self->base.flowheight = ((child->lineheight + self->base.flowheight ));
      printf("FTL:          step flowHeight %s\n", to_string(self->base.flowheight));
    old_child = child;
  }
}

  self->base.totalheight = (inlineflow_totalHeight(self->base.flowheight));
  printf("FTL:     inlineflow_totalHeight %s\n", to_string(self->base.totalheight));
  printf("FTL:         flowHeight %s\n", to_string(self->base.flowheight));
 
 }
 void visit_inlineflow_1(InlineFlow* self, Tree* children, unsigned int num_children) {
  printf("FTL:   visit  InlineFlow %s\n", "1");
 
 }
 void visit_inlineflow_2(InlineFlow* self, Tree* children, unsigned int num_children) {
  printf("FTL:   visit  InlineFlow %s\n", "2");
  self->base.flowx = (inlineflow_flowX(self->base.containingx));
  printf("FTL:     inlineflow_flowX %s\n", to_string(self->base.flowx));
  printf("FTL:         containingX %s\n", to_string(self->base.containingx));
  self->base.flowy = (inlineflow_flowY(self->base.containingy));
  printf("FTL:     inlineflow_flowY %s\n", to_string(self->base.flowy));
  printf("FTL:         containingY %s\n", to_string(self->base.containingy));

  self->childs_posx_init = ((0));
  self->childs_posx_last = (self->childs_posx_init);
  printf("FTL:       init childs@posX %s\n", to_string(self->childs_posx_init));
  printf("FTL:     last init childs_posx_last %s\n", to_string(self->childs_posx_last));
    self->childs_posy_init = ((0));
  self->childs_posy_last = (self->childs_posy_init);
  printf("FTL:       init childs@posY %s\n", to_string(self->childs_posy_init));
  printf("FTL:     last init childs_posy_last %s\n", to_string(self->childs_posy_last));
  {
  InlineBox* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    InlineBox* child = get_inlinebox_child(children+i);
      child->posx = ((self->base.absx + child->right - child->inlinewidth ));
      self->childs_posx_last = child->posx;
      printf("FTL:          step childs@posX %s\n", to_string(child->posx));
      child->posy = ((self->base.absy + child->lineposy + child->baselinefinal - child->inlineascent ));
      self->childs_posy_last = child->posy;
      printf("FTL:          step childs@posY %s\n", to_string(child->posy));
    old_child = child;
  }
}


  self->display_list_init = ((new_display_list()));
  self->base.display_list = (self->display_list_init);
  printf("FTL:       init display_list %s\n", to_string(self->display_list_init));
  printf("FTL:     last init display_list %s\n", to_string(self->base.display_list));
  {
  InlineBox* old_child = NULL;
  for(int i = 0; i < num_children; i++) {
    InlineBox* child = get_inlinebox_child(children+i);
      self->base.display_list = ((add_text_fragment(self->base.display_list, child->posx, child->posy, child->availabletextwidth, child->lineheight)));
      printf("FTL:          step display_list %s\n", to_string(self->base.display_list));
    old_child = child;
  }
}

 
 }
 void visit_inlineflow_3(InlineFlow* self, Tree* children, unsigned int num_children) {
  printf("FTL:   visit  InlineFlow %s\n", "3");
 
 }
