/*
** mrb_apparmor.c - AppArmor class
**
** Copyright (c) Uchio Kondo 2016
**
** See Copyright Notice in LICENSE
*/

#include <sys/apparmor.h>

#include <mruby.h>
#include <mruby/data.h>
#include <mruby/error.h>
#include "mrb_apparmor.h"

#define DONE mrb_gc_arena_restore(mrb, 0);

/*
   typedef struct {
   } mrb_apparmor_data;

   static const struct mrb_data_type mrb_apparmor_data_type = {
     "mrb_apparmor_data", mrb_free,
   };*

   static mrb_value mrb_apparmor_init(mrb_state *mrb, mrb_value self)
   {
     mrb_apparmor_data *data;
     char *str;
     int len;

     data = (mrb_apparmor_data *)DATA_PTR(self);
     if (data) {
       mrb_free(mrb, data);
     }
     DATA_TYPE(self) = &mrb_apparmor_data_type;
     DATA_PTR(self) = NULL;

     mrb_get_args(mrb, "s", &str, &len);
     data = (mrb_apparmor_data *)mrb_malloc(mrb, sizeof(mrb_apparmor_data));
     data->str = str;
     data->len = len;
     DATA_PTR(self) = data;

      return self;
   }
*/

static mrb_value mrb_apparmor_change_profile(mrb_state *mrb, mrb_value self)
{
  char *profile_name;
  int ret;

  mrb_get_args(mrb, "z", &profile_name);
  ret = aa_change_profile(profile_name);
  if(ret < 0) {
    mrb_sys_fail(mrb, "aa_change_profile failed");
  }

  return mrb_fixnum_value(ret);
}

static mrb_value mrb_apparmor_change_onexec(mrb_state *mrb, mrb_value self)
{
  char *profile_name;
  int ret;

  mrb_get_args("z", &profile_name);
  ret = aa_change_onexec(profile_name);
  if(ret < 0) {
    mrb_sys_fail(mrb, "aa_change_onexec failed");
  }

  return mrb_fixnum_value(ret);
}

void mrb_mruby_apparmor_gem_init(mrb_state *mrb)
{
  struct RClass *apparmor;
  apparmor = mrb_define_module(mrb, "AppArmor");
  mrb_define_module_function(mrb, apparmor, "change_profile", mrb_apparmor_change_profile, MRB_ARGS_REQ(1));
  mrb_define_module_function(mrb, apparmor, "change_onexec",  mrb_apparmor_change_onexec,  MRB_ARGS_REQ(1));

  DONE;
}

void mrb_mruby_apparmor_gem_final(mrb_state *mrb)
{
}
