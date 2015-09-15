#ifndef __FIELDS_H__
#define __FIELDS_H__
#include "util.h"
struct BaseFlow {
    int flowwidth;
    DisplayList display_list;
    int totalheight;
    int totalwidth;
    int flowheight;
    int availablewidth;
    int containingx;
    int containingy;
    DisplayList makelist;
    int bottom;
    int absy;
    int absx;
    int flowy;
    int flowx;
    int right;
    /*input*/int screenwidth;
    BaseFlow(
      int screenwidth
    ){
         this->flowwidth = 0;
         this->display_list = new_display_list();
         this->totalheight = 0;
         this->totalwidth = 0;
         this->flowheight = 0;
         this->availablewidth = 0;
         this->containingx = 0;
         this->containingy = 0;
         this->makelist = new_display_list();
         this->bottom = 0;
         this->absy = 0;
         this->absx = 0;
         this->flowy = 0;
         this->flowx = 0;
         this->right = 0;
         this->screenwidth = screenwidth;
    }
};
struct InlineBox {
    int lineposy;
    int lineheight;
    int posy;
    bool endofline;
    int posx;
    int baselinefinal;
    int baseline;
    int availabletextwidth;
    int right;
    /*input*/bool mustendline;
    /*input*/int inlinewidth;
    /*input*/int inlineheight;
    /*input*/int inlineascent;
    InlineBox(
      bool mustendline,
      int inlinewidth,
      int inlineheight,
      int inlineascent
    ){
         this->lineposy = 0;
         this->lineheight = 0;
         this->posy = 0;
         this->endofline = false;
         this->posx = 0;
         this->baselinefinal = 0;
         this->baseline = 0;
         this->availabletextwidth = 0;
         this->right = 0;
         this->mustendline = mustendline;
         this->inlinewidth = inlinewidth;
         this->inlineheight = inlineheight;
         this->inlineascent = inlineascent;
    }
};
struct BlockFlow {
    BaseFlow base;
    /*input*/InputLength paddingtop;
    /*input*/InputLength margintop;
    /*input*/InputLength marginleft;
    /*input*/InputLength marginright;
    /*input*/int borderbottom;
    /*input*/int borderleft;
    /*input*/InputLength paddingleft;
    /*input*/InputLength paddingright;
    /*input*/InputLength boxstyleheight;
    /*input*/InputLength marginbottom;
    /*input*/bool is_root;
    /*input*/InputLength boxstylewidth;
    /*input*/int bordertop;
    /*input*/int borderright;
    /*input*/InputLength paddingbottom;
    int mbpvert;
    int mr;
    int mt;
    int childsheight;
    int mbphoriz;
    int computedwidth;
    int selfintrinswidth;
    int br;
    int bt;
    int bl;
    int pb;
    int childswidth;
    int mb;
    int pl;
    int pt;
    int selfintrinsheight;
    int bb;
    int ml;
    int pr;
    int childs_bottom_init;
    int childs_bottom_last;
    int childs_availablewidth_init;
    int childs_availablewidth_last;
    int childs_absx_init;
    int childs_absx_last;
    int childswidth_init;
    int childswidth_last;
    int childsheight_init;
    int childsheight_last;
    int childs_right_init;
    int childs_right_last;
    int childs_absy_init;
    int childs_absy_last;
    int childs_containingx_init;
    int childs_containingx_last;
    int childs_containingy_init;
    int childs_containingy_last;
    DisplayList display_list_init;
    DisplayList display_list_last;
    BlockFlow(
      BaseFlow base,
      InputLength paddingtop,
      InputLength margintop,
      InputLength marginleft,
      InputLength marginright,
      int borderbottom,
      int borderleft,
      InputLength paddingleft,
      InputLength paddingright,
      InputLength boxstyleheight,
      InputLength marginbottom,
      bool is_root,
      InputLength boxstylewidth,
      int bordertop,
      int borderright,
      InputLength paddingbottom
    ) : base(base) {
               this->paddingtop = paddingtop;
         this->margintop = margintop;
         this->marginleft = marginleft;
         this->marginright = marginright;
         this->borderbottom = borderbottom;
         this->borderleft = borderleft;
         this->paddingleft = paddingleft;
         this->paddingright = paddingright;
         this->boxstyleheight = boxstyleheight;
         this->marginbottom = marginbottom;
         this->is_root = is_root;
         this->boxstylewidth = boxstylewidth;
         this->bordertop = bordertop;
         this->borderright = borderright;
         this->paddingbottom = paddingbottom;
         this->mbpvert = 0;
         this->mr = 0;
         this->mt = 0;
         this->childsheight = 0;
         this->mbphoriz = 0;
         this->computedwidth = 0;
         this->selfintrinswidth = 0;
         this->br = 0;
         this->bt = 0;
         this->bl = 0;
         this->pb = 0;
         this->childswidth = 0;
         this->mb = 0;
         this->pl = 0;
         this->pt = 0;
         this->selfintrinsheight = 0;
         this->bb = 0;
         this->ml = 0;
         this->pr = 0;
         this->childs_bottom_init = 0;
         this->childs_bottom_last = 0;
         this->childs_availablewidth_init = 0;
         this->childs_availablewidth_last = 0;
         this->childs_absx_init = 0;
         this->childs_absx_last = 0;
         this->childswidth_init = 0;
         this->childswidth_last = 0;
         this->childsheight_init = 0;
         this->childsheight_last = 0;
         this->childs_right_init = 0;
         this->childs_right_last = 0;
         this->childs_absy_init = 0;
         this->childs_absy_last = 0;
         this->childs_containingx_init = 0;
         this->childs_containingx_last = 0;
         this->childs_containingy_init = 0;
         this->childs_containingy_last = 0;
         this->display_list_init = new_display_list();
         this->display_list_last = new_display_list();
    }
};
struct InlineFlow {
    BaseFlow base;
    int childs_lineposy_init;
    int childs_lineposy_last;
    int childs_availabletextwidth_init;
    int childs_availabletextwidth_last;
    int flowheight_init;
    int flowheight_last;
    int childs_lineheight_init;
    int childs_lineheight_last;
    int childs_baseline_init;
    int childs_baseline_last;
    bool childs_endofline_init;
    bool childs_endofline_last;
    int childs_baselinefinal_init;
    int childs_baselinefinal_last;
    int childs_right_init;
    int childs_right_last;
    int childs_posy_init;
    int childs_posy_last;
    DisplayList display_list_init;
    DisplayList display_list_last;
    int childs_posx_init;
    int childs_posx_last;
    InlineFlow(
      BaseFlow base
    ) : base(base) {
               this->childs_lineposy_init = 0;
         this->childs_lineposy_last = 0;
         this->childs_availabletextwidth_init = 0;
         this->childs_availabletextwidth_last = 0;
         this->flowheight_init = 0;
         this->flowheight_last = 0;
         this->childs_lineheight_init = 0;
         this->childs_lineheight_last = 0;
         this->childs_baseline_init = 0;
         this->childs_baseline_last = 0;
         this->childs_endofline_init = false;
         this->childs_endofline_last = false;
         this->childs_baselinefinal_init = 0;
         this->childs_baselinefinal_last = 0;
         this->childs_right_init = 0;
         this->childs_right_last = 0;
         this->childs_posy_init = 0;
         this->childs_posy_last = 0;
         this->display_list_init = new_display_list();
         this->display_list_last = new_display_list();
         this->childs_posx_init = 0;
         this->childs_posx_last = 0;
    }
};
#endif
