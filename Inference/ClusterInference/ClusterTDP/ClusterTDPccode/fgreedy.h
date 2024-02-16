
#ifndef _FGREEDY_
#define _FGREEDY_

#include <stdio.h>
#include <stdbool.h>

#define CND_SIZE 1
#define CND_KVAL 2
#define CND_K2SIZERATIO 3


struct condition;
typedef struct condition
{		
	int type;
	int op;	
	int val;
	double valf; // ugly, use unions	
	struct condition *next;
} condition;

#define MAXCOMPONENTS 200


struct component;


typedef struct
{
	
	int candidateclusterscnt_s;       // s
	float allowedmissingvoxels_a;     // a
	float allowedmissingvoxelsstep_A; // A
	int runs_r;                       // r

	int resamplecount_e;			// e
	int resampleruns_E;               // E
	int randomizeallowedstep_R;       // R	
	int maxclusterinserted_M;			// M

	float resamplelocalthreshold_q;   // q
	double timelimit_T;				// T

	char *name; 					// PS:...
	bool mscontinue;                 // continue 
	bool initial; 

	bool runsset; 
	
	struct condition *conditions;

	float fitness; 
	int repeats;

	double insertclusteradv; 
	

	struct component *comp;

	// used only in initialps
	bool reducepool;
	float poolreduction_threshold;
	float poolreduction_eqthreshold;



} parameters;

// To add a new parameter:
// tools.c:setparameter (parsing)
// toolc.c:initparams (initializing)


#define SP_OUTSIDE  128
#define SP_VISITED2  16
#define SP_VISITED   8
#define SP_SEPARATOR 4
#define SP_CLUSTER   2
#define SP_VOXEL 1
// 8 is spare

#define OUTSIDE_SPECID -13

#ifdef LARGE
typedef int voxelid;
#else
typedef short int voxelid;
#endif

#define MAXX 128
#define MAXY 128
#define MAXZ 128

#define NEIGHBOURHOODSIZE 26

extern int	writeoutputfiles;
extern int supressstdout;

#define greedylog(...) { if (verbose_writeoutputfiles_Q){\
	FILE *out = fopen(cnf->logfile,"a"); \
   	greedylogf(out, __VA_ARGS__); fclose(out); } if (!verbose_supressstdout_q) greedylogf(stdout, __VA_ARGS__); } 

#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))

#define XYZ(vx) g->v[vx].x,g->v[vx].y,g->v[vx].z


typedef struct {
	int x;
	int y;
	int z;
	voxelid clusterid;   // cluster id from the input file
	voxelid pos; // position from the input file (starts from 1)
	voxelid compid; // id in component
	voxelid cid;    // component id 
	short int nghlen; // how many neighbours
} voxel;

#define VXADD(v,X,Y,Z) { ((v).x)+=(X); ((v).y)+=(Y); ((v).z)+=(Z); }
#define VXADDVX(v,w) VXADD(v, w.x, w.y, w.z)
#define VXSUBVX(v,w) VXADD(v,-w.x,-w.y,-w.z)


#define MAXPARAMETERSETS 100

typedef struct
{

	int optk; 					 // k

	parameters parsets[MAXPARAMETERSETS];	// PS's
	int parsetlen;

	parameters *_p; // current parameters
	
	double timetest;
	bool checkonly;

	char *logfile;
	char *tsvfile;	
	char *projectname;
	char *inputfile;
	char *filesuffix;
	char *projectinfo;
	char *brieftsv;

	long int stoponscore;

	// global parameters
	// TODO: define as params
	double globaltimelimit; 
	bool globaltimelimitset; 
	int noimprovementrunthreshold;
	double noimprovementtimethreshold;
	double timeimproved;



	unsigned int randomseed;

	int onecomponentoonly; 

	bool poolreduction_resetfittness;




} config;


enum Operators  { OAssignment = 1, OPS, OEq = 10, ONe, OLe, OLt, OGe, OGt };

#define BUFS 10000 // size of char buffers

typedef voxelid ngharr[NEIGHBOURHOODSIZE+1];

typedef struct {
	voxel* v;      // array of voxels	
	int _vsize;    // mem size of v
	int len;	
} voxelbuf;

typedef struct {
	voxelid* v;      // array of voxels

	int _vsize;    // mem size of v
	int len;	
} voxelidbuf;

typedef unsigned char statustype;

struct graph;

typedef struct component
{	 
	 int cid;                    // component cid

	 voxel** v;      // array of voxels indexed 1..vlen; index is a voxelid; voxelid 0 - is not used
	 statustype *status;
	 int len;
	 ngharr *ngh;  // precomputed array of neighbours voxelids; the last is 0

	 voxel range; 
	 voxel shift;  // shift

	 
	 // voxelid *t;                 // main voxelid storage


	 int tscore;                 // score stored in t
	 
	 voxelid *minscoreseparator; // best separator
	 int minscore;               // score stored in minscore separator

	 bool validminscoredata;   // true iff minscoreseparator and t have the same data  


	 int impscore;
	 int improvementstep;
	 int runs;
	 double totaltime;
	 double resamplingtime;
	 int resamplingimproved;
	 int resampleruns;

	 struct graph *g; // back reference
	 // statustype *vstatus;  // copy from graph

	 bool hasclustering;

	 parameters *parsets;        // PSs assigned to component
	 parameters initialps;     	 
	 int parsetlen;

	 int easy;
	 double timeimproved;
	 bool active;




} component;

typedef struct graph {
//	voxel* v;      // array of voxels indexed 1..vlen; index is a voxelid; voxelid 0 - is not used
	int vlen;	   
	
	// statustype *vstatus;

	voxel *vx;
	
	component **comp;	   // components
	int complen;

	component **cpool;   // pool of components to evaluate
	int cpoollen;

	component *easycomp; // trivial (easy) components (size <=k+1)
	int easycomplen;	

	voxel* easyv;        // easy voxels; order based on easy clusters 

	int easyvlen;
	int easyplus;        // number of components of size k+1

	int minscore;        // minscore cost
	int tscore;          // cost from t buffers
	int initialminscore;
	int tsvcreated;

	double totaltime;
	double globalstarttime;
	double localstarttime; // for the set	

    voxel range;
    voxel shift;  // shift  (global)

} graph;

void greedylogf(FILE *f, const char *fmt,...);
void readparameters(config *cnf, char *src);

double gettimestr(char *s);
double gettime(); 
void initconfig(config *cnf);
void greedyloginit(char *fn);
void usage(config *cnf);

void configsummary(config *cnf, int prallsets);

// (un)pretty printing
void ppconfig(config *cnf, int prallsets);

#define ppvoxel(v) printf("(%d,%d,%d)",(v).x,(v).y,(v).z)
#define ppvoxellog(v) greedylog("(%d,%d,%d)",v.x,v.y,v.z)

void ppparameters(config *cnf, parameters *p);
void pptimestats(graph *g, config *cnf, int step);
void ppgraph(graph *g, int printvoxels, config *cnf);
void ppimpstats(graph *g, config *cnf, int step);

// tools

char *getuniquename(char *b, char *prjname, int score, char *suffix, int *renamed);
char *locateminscorefile(char *dirname, int *retminscore, int report);
char *preparecnf(config *cnf, char *continuedir, char *inputfile);

int readxyz(const char *fn, voxelbuf *vs);
int addvoxelid(voxelidbuf *b, voxelid v);
void initvoxelbuf(voxelbuf *vs, int vsize);
void initvoxelidbuf(voxelidbuf *vs, int vsize);
int addvoxel(voxelbuf *b, int x, int y, int z, voxelid clusterid);


#define STATUS(id) (comp->status[id])

void cidseparator2minscore(component *c);

// minscoreseparator -> clustering
int genminscoreclustering(graph *g);

extern bool verbose_writeoutputfiles_Q;
extern bool verbose_supressstdout_q;


// Gen clusters id from comp.minscoreseparator's
// ids are 0(separator),1(first cluster),2,..,lastid
// returns lastid+1
int genclusterids(component *comp, config *cnf, int clusterid);


// Neighbour looping macros

#define NEIGHBOURSLOOP() for (int _i=0; _i<NEIGHBOURHOODSIZE; _i++)
#define NEIGHBOURSINIT(cur)\
				int nbx=comp->v[cur].x+nghvect[_i][0];\
				int nby=comp->v[cur].y+nghvect[_i][1];\
				int nbz=comp->v[cur].z+nghvect[_i][2];\
    			voxelid nbid = space2id[nbx][nby][nbz];

#define NEIGHBOURSLOOP2(voxid) for (voxelid *_a = comp->ngh[voxid]; *_a; *_a++)
#define NEIGHBOURSINIT2(voxid) \
    voxelid nbid = *_a;    \
    statustype nbcell = comp->status[nbid];


int regularitychecker(graph *g, config *cnf);
int genminscoreclusteringcomp(component *c);
void ppcomponent(component *comp);
int initializecomponentPSs(component *comp, config *cnf);


void _ppspacem(
	component *comp,
	int mark, char *markinfo,
	voxelid *others, int otherslen, char *othersinfo,
	voxelid *others2, int otherslen2, char *othersinfo2);

#define ppspace(g) _ppspacem(g,-1,NULL,0,0,0,0,0,0);
#define ppspace1(g,mark,pi,ar1,ar1len,ar1inf) _ppspacem(g,mark,pi,ar1,ar1len,ar1inf,0,0,0);
#define ppspace2(g,mark,pi,ar1,ar1len,ar1inf,ar2,ar2len,ar2inf) _ppspacem(g,mark,pi,ar1,ar1len,ar1inf,ar2,ar2len,ar2inf);

void ppcode(statustype n, graph *g);

// #define SCORE_CTRL_DEBUG

void ppscoreg(graph *g, bool activeonly, config *cnf);

int findkval(char *fn);
#endif
