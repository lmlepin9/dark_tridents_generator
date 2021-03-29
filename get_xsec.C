#include <iostream>
#include <stdio.h>
#include <fstream>
#include <unistd.h>
#include <sstream>

#include "TCanvas.h"
#include "TChain.h"
#include "TGraph.h"
#include "TROOT.h"
#include "TFile.h"


void get_xsec() {
    gROOT->SetBatch(kTRUE);
    TChain t("xsec");
    t.Add("events/events_*MeV.root");
    int n = t.Draw("xsec:eX","","goff");
    if(n <= 0) return;
    map<double,double> points;
    for(int i = 0; i < n; ++i) points[t.GetV2()[i]]=t.GetV1()[i];
    vector<double> px(n),py(n);
    map<double,double>::iterator p = points.begin();
    for(int i = 0; i < n; ++i) {
        px[i] = p->first;
        py[i] = p->second;
        p++;
    }
    TGraph *g = new TGraph(n,px.data(),py.data()); 
    g->SetName("ggg");
    g->SetBit(TGraph::kIsSortedX);

    TFile f("cross_section.root", "RECREATE");
    g->Write();
    f.Close();

}