#include "history_data.h"
using namespace std;

void wrap_HistoryData_free (HistoryData* ptr)
{
  ptr->~HistoryData();
  ruby_xfree(ptr);
}

VALUE wrap_HistoryData_allocate (VALUE self)
{
    void* p = ruby_xmalloc (sizeof(HistoryData));
    return Data_Wrap_Struct (self, NULL, wrap_HistoryData_free, p);
}

VALUE wrap_HistoryData_initialize (VALUE self)
{
    HistoryData* p;
    Data_Get_Struct(self, HistoryData, p);

    new (p) HistoryData();

    return Qnil;
}

VALUE wrap_HistoryData_load (VALUE self, VALUE v_csv)
{
  HistoryData* p;
  Data_Get_Struct(self, HistoryData, p);
  char* csv = StringValuePtr(v_csv);

  int index = p->load(csv);
  return INT2FIX(index);
}

// type :: DataType 0:String, 1:Fixnum, 2:Float, 3:Time
VALUE wrap_HistoryData_get(VALUE self, VALUE v_type, VALUE v_index, VALUE v_pos, VALUE v_size){
  HistoryData* p;
  Data_Get_Struct(self, HistoryData, p);
  int type = FIX2INT(v_type);
  int index = FIX2INT(v_index);
  unsigned long pos = FIX2ULONG(v_pos);
  int size = FIX2INT(v_size);

  VALUE value;
  switch(type){
  case 0:
    char txt[256];
    p->get(index, pos, size, &txt);
    value = rb_str_new2(txt);
    break;
  case 1:
    long num;
    p->get(index, pos, size, &num);
    value = LONG2FIX(num);
    break;
  case 2:
    double fl;
    p->get(index, pos, size, &fl);
    value = DBL2NUM(fl);
    break;
  case 3:
    time_t time;
    long usec;
    p->get(index, pos, 4, &time);
    p->get(index, pos+4, 4, &usec);
    value = rb_time_new(time, usec);
    break;
  }
  return value;
}

VALUE wrap_HistoryData_moving_average(VALUE self, VALUE v_index, VALUE v_pos, VALUE v_period){
  int index = FIX2INT(v_index);
  unsigned long pos = FIX2ULONG(v_pos);
  int period = FIX2INT(v_period);
  HistoryData* p;
  Data_Get_Struct(self, HistoryData, p);
  double average = p->moving_average(index, pos, period);
  return DBL2NUM(average);
}

// type :: DataType 0:year, 1:month, 2:day, 3:hour ,4:minute, 5:second, 6: Day of week, 7: day of year
VALUE time_to_type(VALUE self, VALUE v_type, VALUE v_time){
  int type = FIX2INT(v_type);
  time_t mytime = NUM2LONG(v_time);
  time_t now = time(NULL);
  tm const *time_out = localtime(&mytime);
  VALUE value;
  switch(type){
  case 0:
    value = INT2FIX(time_out->tm_year+1900);
    break;
  case 1:
    value = INT2FIX(time_out->tm_mon+1);
    break;
  case 2:
    value = INT2FIX(time_out->tm_mday);
    break;
  case 3:
    value = INT2FIX(time_out->tm_hour);
    break;
  case 4:
    value = INT2FIX(time_out->tm_min);
    break;
  case 5:
    value = INT2FIX(time_out->tm_sec);
    break;
  case 6:
    value = INT2FIX(time_out->tm_wday);
    break;
  case 7:
    value = INT2FIX(time_out->tm_yday);
    break;
  }
  return value;
}

extern "C" {
  void Init_history_data()
  {
    VALUE c = rb_define_class ("HistoryData", rb_cObject);

    // C++のクラス定義に相当する
    rb_define_alloc_func(c, wrap_HistoryData_allocate);
    rb_define_private_method (c, "initialize", (VALUE(*)(...))wrap_HistoryData_initialize, 0);

    rb_define_method (c, "load", (VALUE(*)(...))wrap_HistoryData_load, 1);
    rb_define_method (c, "get", (VALUE(*)(...))wrap_HistoryData_get, 4);
    rb_define_method (c, "moving_average", (VALUE(*)(...))wrap_HistoryData_moving_average, 3);
    rb_define_global_function ("rb_time_to_type", (VALUE(*)(...))time_to_type, 2);
  }
}
