#include <stdio.h>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include "ruby.h"

using namespace std;

class HistoryData
{
public:
  HistoryData ();
  ~HistoryData();

  int load(char *csv);
  void get(int index, unsigned long pos, int size, void* arg);

  double moving_average(int index, unsigned long pos, int period);

  int symbol_amount;
  char *bar_data[256];
};
