#include "history_data.h"
using namespace std;



HistoryData::HistoryData(){
  symbol_amount = -1;
}

HistoryData::~HistoryData(){
  for(int i=0;i<symbol_amount;i++){
    free(bar_data[i]);
  }
}

int HistoryData::load(char *csv){
  fstream file;
  file.open(csv, ios::in | ios::binary);

  file.seekg(0, ios::end);
  streampos filesize = file.tellg();
  file.seekg(0, ios::beg);

  symbol_amount++;
  bar_data[symbol_amount] = (char *) malloc(filesize);
  file.read((char *)bar_data[symbol_amount], filesize);

  file.close();

  return symbol_amount;
}

void HistoryData::get(int index, unsigned long pos, int size, void* arg){
  memcpy(arg, bar_data[index] + pos, size);
  return;
}

// calcurate average from pos pointer and period
double HistoryData::moving_average(int index, unsigned long pos, int period){
  double price;
  double sum = 0;
  for(int i=0;i<period;i++){
    get(index, pos - i*44, 8, (void*)&price);
    sum += price;
  }
  return sum/period;
}
