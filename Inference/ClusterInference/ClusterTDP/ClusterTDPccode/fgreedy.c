#include <stdio.h>
#include <stdlib.h>

#include <ctype.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <math.h>

#include <libgen.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <getopt.h>
 
#include "fgreedy.h"

//#define TESTING

#ifdef TESTING
// #define DEBUG_EXPANDSEPARATOR		
// #define DEBUG_FINDSUBGRAPH
#define DEBUG_RESAMPLE
#define DEBUG_RESAMPLE2
#define DEBINF printf("\nIn %s:%s:%d:",__func__,__FILE__,__LINE__)

#endif

int nghvect[NEIGHBOURHOODSIZE][3] = {
	{0,0,1}, 	{0,0,-1}, 	 {0,1,0}, 	{1,0,0}, 	{-1,0,0}, 	{0,-1,0}, 
	{0,1,1}, 	{0,1,-1},  	 {0,-1,1}, 	{0,-1,-1}, 	{1,0,1}, 	{1,0,-1},
	{-1,0,1}, 	{-1,0,-1},   {1,1,0}, 	{1,-1,0}, 	{-1,1,0}, 	{-1,-1,0},
	{1,-1,1}, 	{1,1,1}, 	{1,1,-1}, 	{1,-1,-1}, 	{-1,1,1}, 	{-1,1,-1}, 	{-1,-1,1}, 	{-1,-1,-1} };

int nbidx[NEIGHBOURHOODSIZE] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25};


char *verbose = "";

bool verbose_writeoutputfiles_Q=true;
bool verbose_supressstdout_q=false;
bool verbose_ppstage1_1 = false;  
bool verbose_esteps_r = false;  
bool verbose_ppstage2_2 = false;  
bool verbose_ppscores_3 = false;  
bool verbose_scoreafterrefill_4 = false;  

bool verbose_forcewritingtsv_f=false;   // used to force tsv writing when there is no improvement in the score
bool verbose_clustersizes_C = false;  
bool verbose_PSstats_s = false;  
bool verbose_PSstats_5 = false;  
bool verbose_initialscores_0 = false;  
bool verbose_PSstats_F = false;  
bool verbose_graphprop_G = false;  
bool verbose_ignoretrivial_i = false;  
bool verbose_resamplingimprovements_R = false;
bool verbose_scorepool_o = false;
bool verbose_SmpStats_T = false;

typedef struct 
{	
	voxelid *cluster;
	voxelid *border;
	int borderfirst;
	int borderend;
	int clustersize;
} canddata;

int saveclusters(graph *g, char *fn, config *cnf)
{

	if ((g->initialminscore>=0) && (g->initialminscore<=g->minscore) && ! verbose_forcewritingtsv_f)
	{
		greedylog("No score improvement -> no output tsv file\n");
		return 0;
	}


					
	genminscoreclustering(g);	

	int clusterid = 0; 
	for (int i = 0; i<g->complen; i++)
			clusterid = genclusterids(g->comp[i],cnf,clusterid);

	for (int i = 0; i<g->easycomplen; i++)
	{
			component *comp = g->comp[g->complen + i];
			for (int cur=1; cur<=comp->len; cur++)			
					comp->v[cur]->clusterid = clusterid;					
			
			clusterid++;
	}

#define XYZshift(vox) (vox).x+g->shift.x,(vox).y+g->shift.y,(vox).z+g->shift.z
#define XYZshiftclu(vox) XYZshift(vox),vox.clusterid

	// for (int i=1; i<=g->vlen; i++) vox2comp[i]=g->complen+1; 
	// for (int i = 0; i < g->complen; ++i)		
	// 		for (int j=1; j <= g->comp[i].len; ++j)			
	// 				vox2comp[g->comp[i].t[j]] = i;	

	// check
	int sep=0; //control
	int clu=0;	

	for (int i=1;i<=g->vlen;i++) 
	{	
		if (g->vx[i].clusterid) clu++; else sep++;
		if ((g->vx[i].cid>=g->complen+g->easycomplen+1) || g->vx[i].cid<0)
		{
			fprintf(stderr,"Sth is wrong with the clustering...\n");
			exit(-1);
		} 	
	}
	
	if (clu+sep!=g->vlen)
	{
		fprintf(stderr, "Not all clusters saved (impossible!)? save=%d vs all=%d \n",clu+sep,g->vlen);
		exit(-1);
	}

// #define addbuf(pos,vox,cluid,comp)     output[pos][0]=vox; output[pos][1]=cluid; output[pos][2]=comp;
// #define addbufeasy(pos,vox,cluid,comp) output[pos][0]=vox+g->vlen+1; output[pos][1]=cluid; output[pos][2]=comp;

	// for (int i = 0; i < g->complen; ++i)		
	// {
	// 		component *comp = g->comp+i;
	// 		for (int j=1; j <= comp->len; ++j)			
	// 		{
	// 			addbuf(comp->v[j]->pos, -10, comp->v[j]->clusterid, i);
	// 			if (comp->v[j]->clusterid) clu++; else sep++;
	// 		}
	// }

	// for (int j = 1; j <= g->vlen; ++j)	 
	// {	
					
	// 	addbuf(g->v[j].pos,j,g->v[j].clusterid,vox2comp[j]);
	// 	if (g->v[j].clusterid) clu++; else sep++;
	// }


	
	int ignoretrivial=verbose_ignoretrivial_i;
	
	// int k=0;
	// for (int i = 0; i < g->easycomplen; ++i)					
	// {
		
	// 	clusterid++;
	// 	for (int j = 0; j < g->easycomp[i].len; ++j)
	// 	{
	// 		if (ignoretrivial)			
	// 			output[g->easyv[k].pos][0]=-1;
	// 		else
	// 		{
	// 			if (j==0 && g->easycomp[i].len==cnf->optk+1)
	// 			{ addbufeasy(g->easyv[k].pos,k,0,clusterid); }
	// 			//fprintf(f,"%d\t%d\t%d\t0\t-%d\n",XYZshift(g->easyv[k]),clusterid);		
	// 		else
	// 			{ addbufeasy(g->easyv[k].pos,k,clusterid,clusterid); }
	// 			// fprintf(f,"%d\t%d\t%d\t%d\t-%d\n",XYZshift(g->easyv[k]),clusterid,clusterid);
	// 		}
	// 		k++;
	// 	}
	// }		


	voxel *v[g->vlen+1];

	// resort
	for (int i=1; i<=g->vlen; i++)
		v[g->vx[i].pos] = g->vx+i;

	FILE *f = fopen(fn,"w");
	if (!f)
	{
		fprintf(stderr, "Cannot create file %s\n", fn);
		exit(-1);
	}

	// for (int i = 0; i < g->complen; ++i)	
	// {	
	// 	component *comp = g->comp+i;
	// 	printf("%d\n",g->comp->len);

	// 	for (int cur = 1; cur <= comp->len; ++cur)
	// 	{
	// 		voxel *v = comp->v[cur];
	// 		greedylog("%d: (%d,%d,%d) %d compid%d cid%d\n",cur,v->x,v->y,v->z,v->clusterid,v->compid,v->cid);
			
			
	// 	}			
	// }

	for (int j = 1; j <= g->vlen; ++j)	 	
	{
		
		// if (vid==-1) continue; //trivial ignore
		// if (vid==0)
		// {
		// 	fprintf(stderr, "Error in saveclusters buffer\n");
		// 	exit(-1);
		// }

		voxel *vx = v[j];
		if (vx->cid >= g->complen)		
			fprintf(f,"%d\t%d\t%d\t%d\t-%d\n",XYZshift(*vx),vx->clusterid,vx->cid);			
		else		
			fprintf(f,"%d\t%d\t%d\t%d\t%d\n",XYZshift(*vx),vx->clusterid,vx->cid);				
		
	}


	fclose(f);
	//greedylog("clusters+separators file:%s\n",fn);
	g->tsvcreated = 1;
	return 1;

}

//#define DEBUG_INSCLUSTER
long clusterinsertions = 0;

// Find a cluster and its border starting from centroid
// Cluster and border data is stored in c
int insertclusterfast(int centroid, component *comp, config *cnf, int size, canddata *c)
{
	voxelid* border = c->border;
	voxelid* cluster = c->cluster;
	border[0] = centroid;
	int bolast = 1;	
	int bofirst = 0;
	int clustersize = 0;

	clusterinsertions++;

	comp->status[centroid]|=SP_VISITED;
	
	while (bolast>bofirst)
	{
		int cur = border[bofirst++];
	
#ifdef DEBUG_INSCLUSTER
		printf(" CUR=");
		ppvoxel(g->v[cur]);		
		printf("\n");
#endif
		
		int ok = !(STATUS(cur)&SP_CLUSTER);
		
		
		for (voxelid *_a = comp->ngh[cur]; *_a; *_a++)		
		{
			voxelid nbid = *_a;   
    	statustype nbcell = comp->status[nbid];

			// todo randomize						
			if (nbcell & SP_CLUSTER) 				
			{								
				ok=0;
				continue;
			}

			if (nbcell == SP_VOXEL) // insert only non-visited voxels
			{			
				STATUS(nbid)|=SP_VISITED;  // mark as visited 
				//add to ccand
				border[bolast++] = nbid;
			}
		}


		
		if (ok)
		{			
			STATUS(cur)|=SP_VISITED2;
			cluster[clustersize++]=cur;
			// printf("\n\nClustersize:%d bofirst=%d bolast=%d cost:%d\n",clustersize,bofirst,bolast,bolast-bofirst);			
			// ppspace(comp);			

		}

#ifdef DEBUG_INSCLUSTER
		ppspace(vs);
		printf("\n:CLUSTER:");
		for (int i = 0; i < clustersize; ++i)	 ppvoxel(g->v[cluster[i]]);	
		printf("clustersize = %d \n",clustersize);

#endif
		if (clustersize==size) break; // done

	}
	//printf("\n");
	
#ifdef DEBUG_INSCLUSTER
	ppspace(vs);

	printf("\n:CLUSTER:");
	for (int i = 0; i < clustersize; ++i)	 ppvoxel(g->v[cluster[i]]);	
	printf("clustersize = %d \n",clustersize);

	printf("\n:BORDER:");
	for (int i = bofirst; i < bolast; ++i) ppvoxel(g->v[border[i]]);	
#endif

	c->borderend = bolast;
	c->borderfirst = bofirst;
	c->clustersize = clustersize;

	//clean
	for (int i = 0; i < clustersize; ++i) STATUS(cluster[i])=SP_VOXEL;	
	for (int i = bofirst; i < bolast; ++i) STATUS(border[i])=SP_VOXEL;

	return bolast-bofirst;
}

int num=1;

// #define DEBUG_INSCLUSTER2
// Find a cluster and its border starting from centroid
// Cluster and border data is stored in c
int insertcluster2(int centroid, component *comp, config *cnf, int minsize, canddata *c)
{
	voxelid* border = c->border;
	voxelid* cluster = c->cluster;
	border[0] = centroid;
	int bolast = 1;	
	int bofirst = 0;
	int clustersize = 0;

	int mbofirst;
	int mbolast;
	int mincost = -1;
	int minclustersize = 0;

	clusterinsertions++;

	comp->status[centroid]|=SP_VISITED;
	
	while (bolast>bofirst)
	{
		int cur = border[bofirst++];
	
		
		int ok = !(STATUS(cur)&SP_CLUSTER);

				
		NEIGHBOURSLOOP2(cur)		
		{
			NEIGHBOURSINIT2(cur);					
			// todo randomize						
			if (nbcell & SP_CLUSTER) 				
			{								
				ok=0;
				continue;
			}

			if (nbcell == SP_VOXEL) // insert only non-visited voxels
			{			
				STATUS(nbid)|=SP_VISITED;  // mark as visited 
				//add to ccand
				border[bolast++] = nbid;
			}
		}
		
		if (ok)
		{			

			// insert cluster
			//STATUS(cur)|=SP_VISITED2;
			cluster[clustersize++]=cur;

			if (mincost==-1 || mincost>=(bolast-bofirst) || clustersize==minsize) // ig
			{
					//if (clustersize==minsize || mincost==-1 || ((1.0*rand()/RAND_MAX)>0.5)) 
					{
						// ignore min solution sometimes to avoid traps
						mbofirst = bofirst;
						mbolast = bolast;
						mincost = bolast-bofirst;
						minclustersize = clustersize;
					}

			}

			
#ifdef DEBUG_INSCLUSTER2
			// if (clustersize>=minsize)
			// {
			num++;
			printf("(%d) Clustersize:%d (minsize=%d) bofirst=%d bolast=%d cost:%d ===>",
				num,
				clustersize,minsize,bofirst,bolast,bolast-bofirst);			
			printf("Min: minclustersize:%d mbofirst=%d molast=%d mcost:%d \n",
				minclustersize,mbofirst,mbolast,mincost);		

			char buf[200];
			sprintf(buf,"/tmp/qpa%d.log",num);

			ppspace(g);
			// FILE *f = fopen(buf,"w");
			// for (int i=1;i<=comp->len;i++)
			// {				
			// 	int st=comp->status[i];
			// 	if (i==centroid) st+=10;
			// 	for (int j=0; j<clustersize;j++) 
			// 		if (i==cluster[j]) st+=5;
			// 	for (int j=bofirst; j<bolast;j++) 
			// 		if (i==border[j]) st=0;
			// 	fprintf(f,"%d\t%d\t%d\t%d\t0\n",comp->v[i]->x,comp->v[i]->y,comp->v[i]->z,st);
			// }

			//fclose(f);
			

				

			// ppspace(comp->g);	
#endif					
		}

		if (clustersize==cnf->optk) break; // done
	}
	//printf("\n");
	// take best

	c->borderend = mbolast;
	c->borderfirst = mbofirst;
	c->clustersize = minclustersize;

	printf(">>Min: minclustersize:%d mbofirst=%d molast=%d mcost:%d \n",
				minclustersize,mbofirst,mbolast,mincost);			

	//clean
	for (int i = 0; i < clustersize; ++i) STATUS(cluster[i])=SP_VOXEL;	
	for (int i = bofirst; i < bolast; ++i) STATUS(border[i])=SP_VOXEL;

	return mincost;
}


//#define DEBUG_INSCLUSTER3
// Find a cluster and its border starting from centroid
// Cluster and border data is stored in c
int insertclusteradv(int centroid, component *comp, config *cnf, int minsize, canddata *c)
{
	voxelid* border = c->border;
	voxelid* cluster = c->cluster;
	border[0] = centroid;
	int bolast = 1;	
	int bofirst = 0;
	int clustersize = 0;

	int mbolast;
	int mincost = -1;
	int minclustersize = 0;

	clusterinsertions++;
	int range[cnf->optk+1];

#ifdef DEBUG_INSCLUSTER3
	printf("=============INS3 START ++++++++++\n");
	ppspace(comp);
#endif
	
	for (int i=1; i<=comp->len; i++)
		if (comp->status[i] & SP_VISITED)
		{
			printf("VISITED?\n");
			exit(-1);
		}

	comp->status[centroid]|=SP_VISITED;

	int cost=1; // includes the current 
	
	while (bolast>bofirst)
	{
		// find the cheapest candidate to insert		
		int mincnt = -1;
		int minvox = -1;

		int b = bofirst;
		while (b<bolast)
		{		
				voxelid cur = border[b];		
				if (cur<0)
				{								
						if (b++==bofirst) bofirst++;						
						continue;
				}
				
				int qcand = 0;				
				int cnt=0;
				NEIGHBOURSLOOP2(cur)		
				{
					NEIGHBOURSINIT2(cur);							
					if (nbcell == SP_VOXEL) // insert only non-visited voxels						
						cnt++;				
				}

				if (mincnt==-1 || mincnt>cnt)
				{
					minvox = b;
					mincnt = cnt;
				}

				if (!mincnt) break; // found 0
				b++;
		}

		if (minvox==-1) break; // completed

		// do the rest

		// minvox best to insert
		int cur = border[minvox];
		int ok = !(STATUS(cur)&SP_CLUSTER);
				
		NEIGHBOURSLOOP2(cur)		
		{
			NEIGHBOURSINIT2(cur);					
			// todo randomize						
			if (nbcell & SP_CLUSTER) 				
			{				
				// cur is a separator				
				ok=0; 				
				continue;
			}

			if (nbcell == SP_VOXEL) // insert only non-visited voxels
			{			
				STATUS(nbid)|=SP_VISITED;  // mark as visited 				
				border[bolast++] = nbid;
				cost++;
			}
		}
		
		if (ok)
		{			

			// insert cluster
			//STATUS(cur)|=SP_VISITED2;

			cost--; // one in cluster
			cluster[clustersize] = minvox;
			border[minvox] = -border[minvox]; // convert to cluster voxel
			range[clustersize] = bolast;
			clustersize++;

			if (mincost==-1 || mincost>=cost || clustersize==minsize) // ig
			{					
					mbolast = bolast;
					mincost = cost;
					minclustersize = clustersize;				
			}

			
#ifdef DEBUG_INSCLUSTER3
			// if (clustersize>=minsize)
			// {
			num++;
			printf("..............................\n(%d) Clustersize:%d (minsize=%d) mincnt=%d bofirst=%d bolast=%d cost=%d ===>",
				num,
				clustersize,minsize,mincnt,bofirst,bolast,cost);			
			printf("Min: minclustersize:%d molast=%d mcost:%d \n",
				minclustersize,mbolast,mincost);		


			voxelid others[bolast];
			voxelid others2[bolast];
			int ia=0,ib=0;
			for (int i = 0; i < bolast; ++i)
			{
				if (border[i]<0)
					others[ia++] = -border[i];
				else
					others2[ib++] = border[i];
			}

			ppspace2(comp,0,NULL,others,ia,"CLUS", others2,ib,"BORD");

			printf("\n:CLUSTER (size=%d):",clustersize);
			for (int i = 0; i < clustersize; ++i)	 printf("%d ",cluster[i]);
			printf("\n:BORDER (bolast=%d):",bolast);
			for (int i = 0; i < bolast; ++i)	
				if (border[i]>0)
					printf("%d(%d.%d) ",border[i],comp->v[border[i]]->x,comp->v[border[i]]->y);
				else
					printf("%d(%d.%d) ",border[i],comp->v[-border[i]]->x,comp->v[-border[i]]->y);
			printf("\n");

			// char buf[200];
			// sprintf(buf,"/tmp/qpa%d.log",num);


			// FILE *f = fopen(buf,"w");
			// for (int i=1;i<=comp->len;i++)
			// {				
			// 	int st=comp->status[i];
			// 	if (i==centroid) st+=10;
			// 	for (int j=0; j<clustersize;j++) 
			// 		if (i==cluster[j]) st+=5;
			// 	for (int j=bofirst; j<bolast;j++) 
			// 		if (i==border[j]) st=0;
			// 	fprintf(f,"%d\t%d\t%d\t%d\t0\n",comp->v[i]->x,comp->v[i]->y,comp->v[i]->z,st);
			// }

			// fclose(f);
			

				

			// ppspace(comp->g);	
#endif					
		}

		if (clustersize==cnf->optk) break; // done
	}
	//printf("\n");
	// take best

	c->borderend = mbolast;
	c->borderfirst = 0;
	c->clustersize = minclustersize;

	for (int i=minclustersize; i<clustersize; i++)
		border[cluster[i]] = -border[cluster[i]]; // forget additional cluster members

	for (int i=0; i<minclustersize; i++)
		cluster[i] = -border[ cluster[i] ]; // get cluster

#ifdef DEBUG_INSCLUSTER3
	printf(">>Min: minclustersize:%d molast=%d mcost:%d \n",
				minclustersize,mbolast,mincost);			

		printf("\n:Ret-CLUSTER (size=%d):",c->clustersize);
		for (int i = 0; i < c->clustersize; ++i)	printf("%d(%d.%d) ",cluster[i],comp->v[cluster[i]]->x,
			comp->v[cluster[i]]->y);
		printf("\n:Ret-BORDER (bolast=%d):",c->borderend);
		for (int i = 0; i < c->borderend; ++i)	
			if (border[i]>0)
					printf("%d(%d.%d) ",border[i],comp->v[border[i]]->x,comp->v[border[i]]->y);
			else
					printf("%d(%d.%d) ",border[i],comp->v[-border[i]]->x,comp->v[-border[i]]->y);
			printf("\n");

#endif

#ifdef DEBUG_INSCLUSTER3
	printf("=============BEFORE CLEAN++++++++++\n");
	ppspace(comp);
#endif
	//clean
	// for (int i = 0; i < clustersize; ++i) STATUS(cluster[i])=SP_VOXEL;	
	for (int i = 0; i < bolast; ++i) STATUS(abs(border[i]))=SP_VOXEL;

#ifdef DEBUG_INSCLUSTER3
	printf("=============AFTER CLEAN++++++++++\n");
	ppspace(comp);
#endif
	return mincost;
}

int refillclustering(component *comp, config *cnf, bool cleancomponent, parameters *ps, voxelid *voxels, int voxelslen);


int _findsubgraphcluster(component *comp, int center, int buflen, 
		voxelid *outside, int *outsidelen,
		voxelid *freevoxels, int *freevoxelslen
		)
{

#ifdef DEBUG_FINDSUBGRAPH				 		
	DEBINF;
 		printf("\nIn _findsubgraphcluster center=%d\n",center);
 		_ppspacem(g,center,"center",NULL,0,0);
#endif		

	voxelid border[buflen+1]; 
	int bofirst,bolast;

	border[0] = center;
	bofirst=0; bolast=1;	

	STATUS(center)=SP_VOXEL; 

	while (bolast>bofirst) // looping
	{
		voxelid cur = border[bofirst++];	

#ifdef DEBUG_FINDSUBGRAPH
	DEBINF;
 		printf("\nIn _findsubgraphcluster center=%d\n",center);
 		_ppspacem(g,cur,"cur",border+bofirst,bolast-bofirst,"borderleft");
#endif	

		NEIGHBOURSLOOP2(cur)
		{				
			NEIGHBOURSINIT2(cur);			
			if ((nbcell==SP_VOXEL) || nbcell&(SP_VISITED|SP_OUTSIDE)) continue;   // already visited or outside

			// allowed bit combinations: SP_VISITED - 0,1;  one of SP_CLUSTER or SP_SEPARATOR; VOXEL on; 
			// printf("\n"); ppcode(nbcell,g); printf("\n");

			// 
			if (nbcell & SP_CLUSTER)
					border[bolast++] = nbid;					
			else if (nbcell & SP_SEPARATOR)
					outside[(*outsidelen)++] = nbid;				
			else 
			{
					fprintf(stderr, "(find) Unknown type %d\n",nbcell);
					exit(-1);
			}

			STATUS(nbid)=(nbcell|SP_VISITED); //&~SP_VISITED2;		// remove vis2						
		}		

		statustype c = STATUS(cur);

		if (c & SP_CLUSTER)		


		  STATUS(cur)=SP_VOXEL;
		  freevoxels[(*freevoxelslen)++] = cur;

		
	}
}

#define PINFO(b) printf("ins:%d(%d,%d)",b,g->v[b].x,g->v[b].y);

// optimized
int expandseparator(component *comp, int buflen, 
	voxelid *border, int bolast, 
	voxelid *cands, int *candslen, 
	voxelid *prevseparators, int *prevseparatorslen,
	voxelid *freevoxels, int *freevoxelslen
	)
{
	
	int bofirst =0;	
	int voxelcount = 0;	

	for (int i = 0; i < bolast; ++i)				
		STATUS(border[i])=SP_VISITED2|SP_SEPARATOR|SP_VOXEL;
	

	while (bolast>bofirst) 
	{
		voxelid cur = border[bofirst++];		
		int ok = 1;

		NEIGHBOURSLOOP2(cur)
		{				
			NEIGHBOURSINIT2(cur);			

			if (nbcell & SP_CLUSTER) 
			{ 
				ok=0; 							
				if (cands && !(nbcell&SP_VISITED2))
				{
					cands[(*candslen)++] = nbid;									
					STATUS(nbid)|=(SP_VISITED2);
				}
			}
			// if (nbcell&SP_VISITED2) continue;				
		}

#ifdef DEBUG_EXPANDSEPARATOR				
		DEBINF;
		//ppcode("CUR1:",cur);
		printf("InEXTR ok=%d vc=%d\n",ok,voxelcount);
		_ppspacem(g,cur,"cur",border+bofirst,bolast-bofirst,"left-border");
#endif		

		if (!ok) continue; 
		// has no cluster as neighbour 
		// -> convert to voxel
		// -> explore neighbours
		
		NEIGHBOURSLOOP2(cur)
		{				
			NEIGHBOURSINIT2(cur);
			
			if (nbcell & (SP_OUTSIDE|SP_VISITED2)) continue; // outside subgraph		
			if (nbcell==SP_VOXEL) continue; // already visited

			STATUS(nbid)|=SP_VISITED2;		
			
			// add to expore nbh
			if (nbcell & (SP_SEPARATOR|SP_VOXEL))
				 border[bolast++] = nbid;				
			else 
			{
				fprintf(stderr, "(expnd) Unknown type %d\n",nbcell);
				exit(-1);
			}
		}		

		statustype sp = STATUS(cur);
		if (sp==(SP_VISITED2|SP_VOXEL)) 
			{
				voxelcount++;
				// freevoxels[(*freevoxelslen)++] = cur;
			}

		if (ok && (sp & SP_SEPARATOR))
		{
			//clean
			// convert to voxel			
			STATUS(cur)=SP_VOXEL; // |SP_VISITED2;			
			freevoxels[(*freevoxelslen)++] = cur;
			
			voxelcount++;
			prevseparators[(*prevseparatorslen)++]=cur;
			
		}		

	}
	return voxelcount;
}

bool subar(voxelid *v1, voxelid* v2, int len)
{
	for (int i=0;i<len;i++)
	{
			int fnd=0;
			for (int j=0;j<len;j++)	
				if (v1[i]==v2[j]) { fnd=1; break; }
			if (!fnd) return false;
	}
	return true;
}

bool eqbar(voxelid *v1, voxelid* v2, int len)
{
	return subar(v1,v2,len) && subar(v2,v1,len);	
}
			


int resampleclustering(component *comp, config *cnf, int bigstep, parameters *ps)
{
	// take random voxel
	// remove a cluster with the voxel + some additional clusters		
	// refill clustering
	
	graph *g = comp->g;	
	int len = comp->len;
	
#ifdef DEBUG_RESAMPLE
	printf("================================\n====================\n==================\nINITIAL RESAMPLE\n");	
	DEBINF;
	ppspace(g);
#endif	

	voxelid prevseparators[len];
	int prevseparatorslen=0;
	
	voxelid center;	
	do 
		center = 1+rand()%len;
		// printf("%d ",center);
	while (!(comp->status[center]&SP_CLUSTER));

	
	voxelid outside[len+1];
	int outsidelen = 0;

	voxelid cands[len+1];
	int candslen = 0;

	voxelid freevoxels[len+1];
	int freevoxelslen = 0;

	_findsubgraphcluster(comp, center, len, outside, &outsidelen, freevoxels, &freevoxelslen);
	
#ifdef DEBUG_RESAMPLE
	DEBINF;
	printf("after first _findsubgraphcluster:");
	ppspace2(comp->g,center,"center",outside,outsidelen,"outside",freevoxels,freevoxelslen,"freevoxels");	
#endif


	double starttime;
	double diff = 0;
	double totallocalA = 0;
	double totallocalB = 0;

  //expand outside -> cands
	int voxelcount = expandseparator(
		comp, len, 
		outside, outsidelen, 
		cands, &candslen, 
		prevseparators, &prevseparatorslen,
		freevoxels, &freevoxelslen
		);

	// returns cluster candidates in outside 

#ifdef DEBUG_RESAMPLE
  DEBINF;	
	printf("after first _expandseparator\n");
	ppspace2(comp->g,-1,0,cands,candslen,"cands",freevoxels,freevoxelslen,"freevoxels");	
#endif
		
	int clusterinserted=1;
  // check candidates for cluster expansion
  int curcand;
	for (curcand = 0; curcand < candslen; ++curcand)
	{

		// apply constrained only if at least 2 clusters are present
		// otherwise no effect (waste)
		if (clusterinserted>=2) 
			if (1.0*freevoxelslen/len>ps->resamplelocalthreshold_q || clusterinserted>=ps->maxclusterinserted_M) 		 		
			break;

		outsidelen=0;		
		if (STATUS(cands[curcand])==(SP_VOXEL|SP_VISITED2)) continue; //skip
		if (STATUS(cands[curcand])==SP_VOXEL) continue; //

#ifdef DEBUG_RESAMPLE
		DEBINF;
		printf("start 2.%d _findsubgraphcluster\n",curcand);				
		_ppspacem(comp->g,cands[curcand],"cand",cands,candslen,"candslist",freevoxels,freevoxelslen,"freevoxels");		
#endif		

		_findsubgraphcluster(comp, cands[curcand], len, outside, &outsidelen,freevoxels, &freevoxelslen);
		clusterinserted++;
		
#ifdef DEBUG_RESAMPLE
		DEBINF;
		printf("after 2.%d _findsubgraphcluster",curcand);		
		ppspace2(comp->g,cands[curcand],"cand",outside,outsidelen,"outside",freevoxels,freevoxelslen,"freevoxels");
		printf("current=%d cnadslens=%d\n",curcand,candslen);
#endif		
					
		int c=0;
		int voxelcount2 = expandseparator(comp, len, 
			outside, outsidelen, 
			cands, &candslen, 
			prevseparators, &prevseparatorslen, 
			freevoxels, &freevoxelslen
			);
	
		voxelcount+=voxelcount2;

#ifdef DEBUG_RESAMPLE
		DEBINF;
		printf("after 2.%d _expandseparator (voxelcount2=%d, voxelcount=%d):\n",curcand, voxelcount2, voxelcount);			
		ppspace2(comp->g,cands[curcand],"cand",cands,candslen,"candslist",freevoxels,freevoxelslen,"freevoxels");
		ppspace2(comp->g,cands[curcand],"cand",cands+curcand,candslen-curcand,"candslist(shifted)",freevoxels,freevoxelslen,"freevoxels");
		printf("current=%d candslens=%d\n",curcand,candslen);
		printf("+++++++++++++++++++++++++++++++++++++++++\n\n");
#endif				
	}


	
#ifdef DEBUG_RESAMPLE
	  DEBINF;
		printf("----------------------\n----------------------\n----------------------\n----------------------\nBef. Optloop\n");		
		printf("outsidelen=%d",outsidelen);
		ppspace1(comp->g,-1,0,freevoxels,freevoxelslen,0);
#endif	


#ifdef TESTING

		  // control correctness
		 //  voxelid newvoxelsbuf[len];
		 //  int newvoxelsbuflen=0;
			// for (int i = 0; i < len; ++i)
			// 	{				
			// 	  if (STATUS(t[i])==(SP_VISITED2|SP_VOXEL) || STATUS(t[i])==SP_VOXEL)	
			// 			newvoxelsbuf[newvoxelsbuflen++]=t[i];
			// 	}
#endif

		int oldscore=prevseparatorslen;		

		for (int i = 0; i < freevoxelslen; ++i)												 
				STATUS(freevoxels[i])&=~(SP_VISITED2);	

		// remove visited2 
		for (int i = curcand; i < candslen; ++i)										 		
				STATUS(cands[i])&=~(SP_VISITED2);	
				
			
#ifdef TESTING
			// if (newvoxelsbuflen!=freevoxelslen)
			// {
			// 	printf("Error in newvoxelsbuf newvoxelsbuflen=%d freevoxelslen=%d",newvoxelsbuflen,freevoxelslen);
			// 	exit(-1);
			// }

			// if (!eqbar(newvoxelsbuf,freevoxels,freevoxelslen))
			// {
			// 	printf("Incorrecnt newvoxels buffer\n");
			// 	exit(-1);			
			// }
#endif		


#ifdef DEBUG_RESAMPLE
	DEBINF;
	printf("AFTER. Optloop freevoxelslen=%d outsidelen=%d\n",
				freevoxelslen,  outsidelen);					
	  ppspace1(comp->g,-1,"",cands+curcand,candslen-curcand,"candslist(shifted)");
		printf("current=%d cnadslens=%d\n",curcand,candslen);
		ppspace1(comp->g,-1,"",cands,candslen,"candslist(all)");
		printf("current=%d cnadslens=%d\n",curcand,candslen);
#endif		

	if (clusterinserted>1)
	{
		int rs = ps->resamplecount_e;
		while (rs) 
		{		
			rs--;	

	#ifdef DEBUG_RESAMPLE2
			DEBINF;
			printf ("\n ~~~~~~~~~~~~~~~~~ BEFORE REFILL \n freevoxelslen=%d currentscore=%d\n",freevoxelslen,prevseparatorslen);
				ppspace(comp->g);
	#endif		

	int score = refillclustering(comp, cnf, 0, ps, freevoxels, freevoxelslen);	

	#ifdef DEBUG_RESAMPLE2
		DEBINF;
			printf ("\n ~~~~~~~~~~~~~~~~~ AFTER REFILL newscore=%d improvement=%d\n",score,prevseparatorslen-score);
			ppspace(comp->g);
	#endif		

			if (score<prevseparatorslen)
			{			
	#ifdef DEBUG_RESAMPLE2		
				DEBINF;
				printf("Store data: oldscore=%d newscore=%d\n",prevseparatorslen,score);				
	#endif			

				if (verbose_esteps_r)				
					greedylog(" E-step=%d e-step=%d %+d\n",bigstep,rs,prevseparatorslen-score);
								
				// improvement; overwrite prevseparators
				prevseparatorslen=0;
				for (int k = 0; k < freevoxelslen; ++k)				
					if (STATUS(freevoxels[k])&SP_SEPARATOR)
						prevseparators[prevseparatorslen++]=freevoxels[k];
				
				//control
				if (score!=prevseparatorslen)
				{
					fprintf(stderr, "Wrong separators in resampling\n");
					exit(-1);
				}
				rs+=ps->resamplecount_e;
			}

	#ifdef DEBUG_RESAMPLE2		
			DEBINF;
			ppspace(comp->g);
	#endif
		
			if (rs)			
				for (int k = 0; k < freevoxelslen; ++k)
					STATUS(freevoxels[k])=SP_VOXEL;
		
		}
	}

	// reconstruct clustering; either unchanged or improved if better was found
	for (int k = 0; k < freevoxelslen; ++k)
		STATUS(freevoxels[k])=SP_VOXEL|SP_CLUSTER;			
	
	// set separator
	for (int k = 0; k < prevseparatorslen; ++k)
		STATUS(prevseparators[k])=SP_VOXEL|SP_SEPARATOR;		
	
	// store scoring
	comp->tscore+=prevseparatorslen-oldscore;

#ifdef DEBUG_RESAMPLE
	DEBINF;
		printf("Resample completed");		
		ppspace(comp->g);
		printf("Store data: returndiff=%d prevseparatorslen=%d oldscore=%d \n",prevseparatorslen-oldscore,prevseparatorslen,oldscore);
#endif		

	return prevseparatorslen-oldscore;
}

// new
void processcomponentphase1(parameters *ps, config *cnf, int step)
{	
	component *comp = ps->comp;
	
	double starttime = gettime();	

	if (verbose_ppstage1_1 || verbose_ppstage2_2 || verbose_ppscores_3) 
	greedylog("[%d] Sampling components PS:%s\n", step, ps->name);

	int oldtscore = comp->tscore;

	if (comp->hasclustering && (ps->initial || ps->mscontinue))
	{
		// the clustering is taken from minscore

		comp->tscore = comp->minscore;		
		if (verbose_ppstage1_1)
			greedylog("\tPhase1 #%d by minscore: %d\n", comp->cid, comp->tscore)

		genminscoreclusteringcomp(comp);
	}
	else 
	{
		// previous clustering is cleaned; start a new one
		comp->tscore = refillclustering(comp, cnf, 1, ps, NULL, 0);	
		if (verbose_ppstage1_1)
			greedylog("\tPhase1 #%d by sampling from empty clustering: %d\n", comp->cid, comp->tscore);
	}

	// comp->g->tscore += (comp->tscore - oldtscore);

	if (!comp->hasclustering || (comp->tscore < comp->minscore))
		cidseparator2minscore(comp); //save minscore 	
	
	// update comp time
	comp->totaltime += (gettime()-starttime);	

}

#define PPSUMS(g)  { int ts=(g).easyplus; for (int cid=0; cid<(g).complen; cid++) ts+=(g).comp[cid].tscore; greedylog("(3)graph minscore=%d tscore=%d sum=%d\n",(g).minscore, (g).tscore,ts); }


int processcomponentx(parameters *ps, config *cnf, int step)
{
	component *comp = ps->comp;
	graph *g = comp->g;
	int cid = comp->cid;

	// ppparameters(cnf,ps);	
	
 	processcomponentphase1(ps, cnf, step);

	// if (verbose_ppscores_3)	 
	// 	greedylog("\tScore after Phase1: %d\n",);

	// stage 2: resampling
	int resamplingcnt = 0;

	while (1)
	{
		
		resamplingcnt++;
								 
		int curscore = comp->tscore;

		double starttimeres = gettime();	
								
		if (verbose_ppstage2_2) 				
			greedylog("\n\tPhase2: resampling #%d. Initial score=%d\n", cid, comp->tscore);
			
		comp->resamplingimproved=0;
		int resampleruns_E = abs(ps->resampleruns_E);
		int i=0;	

		while (i<resampleruns_E)
		{					
			// global time control
			if ((cnf->globaltimelimit>0) && (gettime()-comp->g->globalstarttime>cnf->globaltimelimit)) break;

			// local time control
			if ((ps->timelimit_T>0) && (gettime()-comp->g->localstarttime>ps->timelimit_T)) break;

			// run resampling 

			int diff = resampleclustering(comp, cnf, i, ps);

			if (diff<0) 			
			{
				
				comp->resamplingimproved++;

				// longer processing
				resampleruns_E=i+abs(ps->resampleruns_E);

				if (verbose_ppstage2_2) 				
					greedylog("\tPhase2: #%d score=%d (impr)\n",cid, comp->tscore);				
			}			
			i++;			
		}
			
		comp->resampleruns = resampleruns_E;
		comp->resamplingtime += (gettime()-starttimeres);			

		// g->tscore += (comp->tscore - curscore);


		// store if the component clustering is improved		
		if  (comp->tscore < comp->minscore)
		{	
			// store best component score 
			comp->impscore = comp->minscore - curscore;
			comp->improvementstep = step;
			//comp->minscore=curscore;
			int oldscore = g->minscore;
			g->minscore-=comp->impscore;				

			// store minscore separator set				
			cidseparator2minscore(comp);			

			if (verbose_resamplingimprovements_R) 				
			{
				greedylog("[%d] %4d/%d. minscore=%-4d  #%d [%+d]\n",step,resamplingcnt, i, g->minscore, cid, comp->impscore);			
				//ppconfig(cnf);					
			}			
		}

		comp->totaltime += (gettime()-starttimeres);		
		
		// global time control
		if ((cnf->globaltimelimit>0) && (gettime()-g->globalstarttime>cnf->globaltimelimit)) break;
		
		// local time control
		if ((ps->timelimit_T>0) && (gettime()-g->localstarttime>ps->timelimit_T)) break;

		if (ps->resampleruns_E>=0) break; // one run; otherwise run again in batches of the size |resamplerun|
		
	}

	if (verbose_ppscores_3)	
		greedylog("[%d] Score after local resampling: g.tscore=%d g.minscore=%d\n", step, g->tscore, g->minscore);
			
	return g->tscore;
}



/*
	Fill a set of voxelids with clusters
	Assumption: outside border has no SP_VOXEL
	cleans component if cleancomp==true.
	Returns minscore.
	Clustering can be retrived from space.
 */

 //#define DEBRF
		
int refillclustering(component *comp, config *cnf, bool cleancomponent, parameters *ps, 
		voxelid *voxels,
		int voxelslen)
{	

	int optk = cnf->optk;

	voxelid border1[optk*NEIGHBOURHOODSIZE+1]; // candidate buffer
	voxelid cluster1[optk+1]; // cluster buffer

	voxelid border2[optk*NEIGHBOURHOODSIZE+1]; // candidate buffer (min)
	voxelid cluster2[optk+1]; // cluster buffer (min)

	int clsizes[optk+1]; //how many

	if (verbose_clustersizes_C)
		for (int i = 0; i <= optk; ++i) clsizes[i]=0;

	// clean
	if (cleancomponent)	
	{
		for (int i = 1; i <= comp->len; ++i)
			comp->status[i] = SP_VOXEL; 
		comp->validminscoredata = 0;
	}

	
	voxelid freevoxelsbuf[comp->len];
	voxelid* freevoxels = freevoxelsbuf;
	int freevoxelslen=0;

	if (voxels)
	{
		// use provided free voxels set 
		memcpy (freevoxelsbuf, voxels, sizeof(voxelid)*voxelslen);		
		freevoxelslen = voxelslen;	
	}
	else
	{
		// restore free voxels
		// costly
		for (int i = 1; i <= comp->len; ++i)
			if (comp->status[i] == SP_VOXEL) 
				freevoxelsbuf[freevoxelslen++] = i;			
	}

#ifdef DEBRF
	printf("\n\n=======================\n");
	printf("freevoxelslen=%d\n",freevoxelslen);
#endif
	

	canddata c1,c2;
	c1.border = border1;
	c1.cluster = cluster1;
	c2.border = border2;
	c2.cluster = cluster2;

	canddata *pc=&c1,*pcmin=&c2;

	int minscore = 0;

	int allowedmissingvoxels = (int)(ps->allowedmissingvoxels_a<1)?cnf->optk*ps->allowedmissingvoxels_a:ps->allowedmissingvoxels_a;
	int allowedmissingvoxelsstep = (int)(ps->allowedmissingvoxelsstep_A<1)?cnf->optk*ps->allowedmissingvoxelsstep_A:ps->allowedmissingvoxelsstep_A;

	// printf("============================");
	
	while (1)	
	{
		bool first = true;
		int bestscore = -1;				

		for (int i = 0; i < ps->candidateclusterscnt_s; ++i)
		{
			
			int res=comp->g->vlen+1;
			int kp = optk;

			if (!freevoxelslen) break;

			while (kp>=optk-allowedmissingvoxels-1)
			{								
				if (kp<=0) break;

				int centroid = -1;

				if (!freevoxelslen) break;
				
				voxelid vi = rand()%freevoxelslen;	
				centroid = freevoxels[vi];
						
				if (1.0*rand()/RAND_MAX<ps->insertclusteradv) 				
					res = insertclusteradv(centroid, comp, cnf, kp, pc);	  // more advanced but more costly
				else
					res = insertclusterfast(centroid, comp, cnf, kp, pc);	    // faster but may be less optimal


#ifdef DEBRF
			printf("\tAfter insert3: res=%d kp=%d curbest=%d curbestsize=%d\n", res,  kp, bestscore, pcmin->clustersize);
#endif

				// ppspace(comp->g);	
				// store pc into pcmin if bestscore is improved
				if (first || (bestscore > res))
				{
					first = false;
					bestscore = res;				
					// copy to buffer
					canddata *tmp = pcmin; // swap buffers
					pcmin = pc;
					pc = tmp;

#ifdef DEBRF
			printf("\tNew best accepted: res=%d clusize=%d kp=%d\n", res, pcmin->clustersize, kp);
#endif
					if (res<=1) break; // always accept; previous 1
				}
				// next iteration				
				if (ps->randomizeallowedstep_R)				
					kp-=(1+rand()%(2*allowedmissingvoxelsstep-1));				
				else kp-=allowedmissingvoxelsstep;

			}			

			if (res<=1) break;

			//ppspace(g);

		} // for (int i = 0; i < ps->candidateclusterscnt; ...
		

		// accept current
		if (!first)
		{
			
			
			for (int i = 0; i < pcmin->clustersize; ++i) { 				
				STATUS(pcmin->cluster[i])=SP_CLUSTER|SP_VOXEL;	
			}
			
			for (int i = pcmin->borderfirst; i < pcmin->borderend; ++i) 
			{ 
				if (pcmin->border[i]>0)
				{
					STATUS(pcmin->border[i])=SP_SEPARATOR|SP_VOXEL;
					minscore++;
				}
			}			

			// printf("=============INSERTER RF++++++++++\n");
			// ppspace(comp);


			if (verbose_clustersizes_C)
				clsizes[pcmin->clustersize]++;

			comp->validminscoredata = 0;

			int nl=0;
			for (int j = 0; j < freevoxelslen; ++j)
				if (comp->status[freevoxels[j]] == SP_VOXEL) 
					freevoxels[nl++] = freevoxels[j];
			freevoxelslen = nl;			

			#ifdef DEBRF
			printf("---------------------------\n");
			printf("Accepted: size=%d cost=%d minscoreafter=%d left=%d\n",pcmin->clustersize,(pcmin->borderend-pcmin->borderfirst),minscore,freevoxelslen);
			printf("---------------------------\n");
			#endif

		} 
		else break;

	
	} // while (1)

	
	if (verbose_scoreafterrefill_4)
		greedylog("score=%d\n",minscore);
	

	if (verbose_clustersizes_C)
	{
		greedylog("[");	
		for (int i = 0; i <= cnf->optk; ++i)
		{
			if (clsizes[i]) printf("%d=%d ",i,clsizes[i]);
		}
		greedylog("]");	
		if ((clsizes[0]==28 && clsizes[1]==29) || (clsizes[0]==29 && clsizes[1]==28)) { 
			printf("FIND!");
			exit(0);
		}

	}
	
	if (verbose_scoreafterrefill_4) greedylog("\n");	

#ifdef DEBRF
	printf("==========minscore debrf=%d==========\n\n",minscore);
	ppspace(comp);	
	genclusterids(comp, cnf, 0);
#endif
	
	return minscore;
}



int compcomp (const void * elem1, const void * elem2) 
{
    int f = ((component*)elem1)->len;
    int s = ((component*)elem2)->len;    
    if (f < s) return  1;
    if (f > s) return -1;
    return 0;
}

int compminscores (const void * elem1, const void * elem2) 
{
		component *c1 = (*(component**)elem1);
		component *c2 = (*(component**)elem2);			
    int f = c1->minscore;
    int s = c2->minscore;    
    if (f > s) return  1;
    if (f < s) return -1;
    return 0;
}


int initgraph(graph *g, voxelbuf *vb, config *cnf)
{

	double starttime = gettime();
	
	int optk = cnf->optk;
	if (!vb->len) return 1; // empty; resolved
	voxel *v = vb->v;
	g->vx = vb->v;
	g->vlen = vb->len-1;
	statustype vstatus[g->vlen+1];	

	g->tsvcreated = 0;

	// randomize
 	for (int i = g->vlen-1; i >= 0; --i) 
 	{ 
 		int j = rand()%(i+1);
   	voxel tmp = v[i+1]; v[i+1] = v[j+1]; v[j+1] = tmp;    		
  } 

	voxel vmin = vb->v[1];
	voxel vmax = vb->v[1];

	bool hasclustering = 1;
	for (int i = 1; i < vb->len; ++i)
	{
		if (vb->v[i].clusterid<0) 
			hasclustering = 0;
		vmin.x=min(vmin.x,vb->v[i].x);
		vmin.y=min(vmin.y,vb->v[i].y);
		vmin.z=min(vmin.z,vb->v[i].z);

		vmax.x=max(vmax.x,vb->v[i].x);
		vmax.y=max(vmax.y,vb->v[i].y);
		vmax.z=max(vmax.z,vb->v[i].z);				
	}

	VXADD(vmin,-1,-1,-1); // border needed

	//shift voxel set
	for (int i = 1; i <= g->vlen; ++i)	
		VXSUBVX(v[i],vmin);
	

	VXSUBVX(vmax,vmin);
	
	g->shift = vmin;
	g->range = vmax;

	//ugly rep.
	if (vmax.x+1>=MAXX) 
	{
		fprintf(stderr,"Increase MAXX from %d to %d",MAXX,vmax.x);
		exit(-1);
	}
	if (vmax.y+1>=MAXY) 
	{
		fprintf(stderr,"Increase MAXY from %d to %d",MAXY,vmax.y);
		exit(-1);
	}
	if (vmax.z+1>=MAXZ) 
	{
		fprintf(stderr,"Increase MAXZ from %d to %d",MAXZ,vmax.z);
		exit(-1);
	}

	voxelid space2id[MAXX][MAXY][MAXZ];  // pos -> voxelid

	for (int x = 0; x < g->range.x+2; ++x)
		for (int y = 0; y < g->range.y+2; ++y)
			for (int z = 0; z < g->range.z+2; ++z)			
				space2id[x][y][z]=OUTSIDE_SPECID;		
	
	for (int i = 1; i <= g->vlen; ++i)
			space2id[v[i].x][v[i].y][v[i].z]=i;
	
	// clean
	for (int i = 1; i <= g->vlen; ++i)
		vstatus[i] = SP_VOXEL;	

	// gencomponents	

	component c[MAXCOMPONENTS]; 
	int cid = 0;
	int easycomp = 0; // size <=k+1
	g->easyvlen = 0;
	g->easyplus = 0;

	if (verbose_graphprop_G)
	{
		greedylog("Input graph properties:\n  dim:");
		ppvoxellog(g->range);
		greedylog("\n  shift:");
		ppvoxellog(g->shift);
		greedylog("\n  voxels:%d\n",g->vlen);
	}

	voxel **vbuf = (voxel**)malloc(sizeof(voxel*)*(g->vlen+1));
	vbuf[0] = v; // dummy voxel id 0

	for (int i = 1; i <= g->vlen; ++i)
	{		
		if (vstatus[i]!=SP_VOXEL) continue; 

		int compid = 1; 			
		int bofirst=0;
		int bolast=1;
		voxelid border[g->vlen+1]; // candidate buffer
		border[0] = i;
		int ok = 0;
		vstatus[i]=SP_VISITED;	
	
		while (bolast>bofirst)
		{
			voxelid cur = border[bofirst++];	
			voxel *vx = v+cur;
			for (int _i=0; _i<NEIGHBOURHOODSIZE; _i++)				
			{
				int nbx=vx->x+nghvect[_i][0];
				int nby=vx->y+nghvect[_i][1];
				int nbz=vx->z+nghvect[_i][2];				
    		voxelid nbid = space2id[nbx][nby][nbz];							
				if (nbid==OUTSIDE_SPECID) continue;
			 	if (vstatus[nbid] != SP_VOXEL) continue; // visited or outside		 			 			 				 	
			 	vstatus[nbid] = SP_VISITED;		
			 	border[bolast++] = nbid;

			}			
			vx->compid = compid; 			
			vbuf[compid++] = vx;			 // insert into buffer
		}

		c[cid].v = (voxel**)malloc(sizeof(voxel)*compid);		
		c[cid].len = compid-1; // skip dummy 0
		memcpy (c[cid].v, vbuf, sizeof(voxel*)*compid);		
		

		// easy scores
		if (c[cid].len <= optk+1) { 
			easycomp++;
			g->easyvlen+=c[cid].len;
			if (c[cid].len==optk+1) g->easyplus++;
		}		

		cid++;
		if (cid==MAXCOMPONENTS)
		{
			fprintf(stderr,"Too many components. Increase MAXCOMPONENTS macro and recompile.\n");
			exit(-1);
		}
	}


	// sort by size;
	if (cid)	
		qsort (c, cid, sizeof(component), compcomp);		
	
	// insert components
	g->easycomplen = easycomp;
	g->complen = cid - easycomp;
	
	g->comp = (component**)malloc(sizeof(component*)*cid);		


	
	int jc=0, je=g->complen, cjc=0;
	int easycnt=0;	

	double now = gettime();
	
	for (int i = 0; i < cid; ++i)	
	{	

		component *comp = c+i;
		comp->status = (statustype*)malloc(sizeof(statustype)*(comp->len+1));
		comp->cid = i;

		g->comp[i] = (component*)malloc(sizeof(component));
		
		for (int cur = 1; cur <= comp->len; ++cur)		
			comp->v[cur]->cid = i; // assign component id to voxel

		if (comp->len <= optk+1)			
		{			
			comp->easy = true;				
			comp->hasclustering = 1;							
		}
		else
		{			
			comp->easy = false;
			comp->hasclustering = 0;
			comp->minscore = 0;
			comp->tscore = 0;							
		}
		comp->timeimproved = -1; // never improved

		*(g->comp[i]) = *(comp);
	}

	// if (g->easyvlen!=easycnt)
	// {
	// 	fprintf(stderr, "Wrong easy voxels counts\n");
	// 	exit(-1);
	// }
	

	// 
	if (g->easycomplen)
	{
		
		if (verbose_graphprop_G)
			greedylog("Easy voxels (from components of the size<=k+1):\n  voxels:%d; %.2f%%\n  <=k-components:%d\n  k+1-components:%d\n",
			g->easyvlen,100.0*g->easyvlen/g->vlen,g->easycomplen-g->easyplus,g->easyplus);

		// build easy clustering
		for (int i = 0; i < g->easycomplen; ++i)	
		{
			component *comp = g->comp[g->complen+i];
			comp->minscore = comp->len-cnf->optk;
			if (comp->minscore<0) comp->minscore=0;

			comp->minscoreseparator = (voxelid*)malloc(sizeof(voxelid)*2);			
			comp->minscoreseparator[comp->minscore+1] = 0;
			for (int cur = 1; cur <= comp->len; ++cur)								
				comp->status[cur] = SP_VOXEL|SP_CLUSTER;
			if (comp->minscore==1)
			{
				comp->minscoreseparator[0] = 1;
				comp->status[1] = SP_VOXEL|SP_SEPARATOR;
			}			
		}		
	}
	else
	{
		if (verbose_graphprop_G)		
			greedylog("voxels:%d (%.2f%%) in %d non-easy component(s)\n",
					g->vlen-g->easyvlen,
					100.0*(g->vlen-g->easyvlen)/g->vlen,
					g->complen);
		
	}

	if (verbose_graphprop_G)
	{
		greedylog("%d component(s) of the size >k+1:\n",g->complen);
		greedylog("  voxels:%d\n",g->vlen);		
		for (int i = 0; i < g->complen; ++i)		
			greedylog("  Component:#%d; voxels:%d\n",i,g->comp[i]->len);
	}

	// build neighbors
	for (int i = 0; i < g->complen; ++i)	
	{
		component *comp = g->comp[i];
		comp->minscore = 0;
		comp->cid = i;
		comp->improvementstep = -1;
		comp->minscoreseparator = (voxelid*)malloc(sizeof(voxelid)*(g->comp[i]->len+1));
		comp->totaltime = 0;
		comp->resamplingtime = 0;
		comp->validminscoredata = false;
		comp->g = g;
		comp->ngh = (ngharr*)malloc(sizeof(ngharr)*(comp->len+1));
		comp->ngh[0][0] = 0; 

		for (int cur = 1; cur <= comp->len; ++cur)
			{
				int n=0;
				voxel *vx = comp->v[cur];
				for (int _i=0; _i<NEIGHBOURHOODSIZE; _i++)
					{				
						int nbx=vx->x+nghvect[_i][0];
						int nby=vx->y+nghvect[_i][1];
						int nbz=vx->z+nghvect[_i][2];
    				voxelid nbid = space2id[nbx][nby][nbz];

						if (nbid==OUTSIDE_SPECID) continue;    			
						comp->ngh[cur][n++]=v[nbid].compid;						
					}	
			
				// randomize neighbours
				for (int i = n-1; i > 0; i--)
		    	{        
		        	int j = rand() % (i+1);  		        
		        	voxelid tmp = comp->ngh[cur][i];
		        	comp->ngh[cur][i]=comp->ngh[cur][j];
		        	comp->ngh[cur][j]=tmp;
		    	}
				
				comp->ngh[cur][n]=0; // mark last			
				comp->v[cur]->nghlen = n;	 		 
			}
	}

	// for (int i = 0; i < g->complen; ++i)	
	// {	
	// 	component *comp = g->comp+i;
	// 	printf("%d\n",g->comp->len);

	// 	for (int cur = 1; cur <= comp->len; ++cur)
	// 	{
	// 		voxel *v = comp->v[cur];
	// 		greedylog("%d: (%d,%d,%d) %d %d ngh=",cur,v->x,v->y,v->z,v->clusterid,v->compid);
	// 		for (int j=0; comp->ngh[cur][j]; j++) 
	// 			greedylog("%d ",comp->ngh[cur][j]);
	// 		greedylog("\n");
	// 	}			
	// }

	g->minscore = g->easyplus;

	// check correctness of the original clustering (if present)
	// and save it to the separator array
	// printf("hasclustering%d\n",hasclustering);


	if (hasclustering)
	{		

		for (int i = 0; i < g->complen; ++i)	
		{
			component *comp = g->comp[i];
			comp->minscore=0;
			for (voxelid j = 1; j <= comp->len; ++j)		
			{
				voxel *v = comp->v[j];					
				if (!v->clusterid)			
					comp->minscoreseparator[comp->minscore++] = j; // inserted								
			}
			g->minscore += comp->minscore;	
			comp->hasclustering = 1;	
		}
		greedylog("Input score: %d\n",g->minscore); //checking		

		// check cluster sizes:		
		genminscoreclustering(g);
		
		int clusterid=0;
		for (int i = 0; i < g->complen; ++i)	
			clusterid = genclusterids(g->comp[i], cnf, clusterid);

		g->initialminscore = g->minscore;
	}
	else
	{
		g->initialminscore = -1;
		// g->minscore = -1;
	}

	g->totaltime = gettime() - starttime;
	return !g->complen; // if resolved
	   
}


void savetoprojectdir(config *cnf, graph *g)
{
// save logfile & tsvfile to projectdir/score.log 		

		struct stat st = {0};

		if (stat(cnf->projectname, &st) == -1)
		{		
    		mkdir(cnf->projectname, 0700);
		}

    	int lb=strlen(cnf->projectname)+30;
    	char buf1[lb];
   	
    	int renamed=0;
    	int cleversave=strchr(verbose,'m')!=NULL;
    	int save=1;

    	if (cleversave) // dont write minscore
    	{
	    	int score=0;
	    	char *b=locateminscorefile(cnf->projectname,&score,0);
	    	if (b && score==g->minscore) save=0;
	    }

	    if (save)
	    {
	    	getuniquename(buf1,cnf->projectname,g->minscore,cnf->filesuffix, &renamed);
	    	if (cleversave && renamed) // skip  the same filename
	    		save=0;
	    }
   	
    	if (save && g->tsvcreated)
    	{
			if (rename(cnf->tsvfile, buf1))    	
	      		fprintf(stderr,"Warning: unable to rename the file %s -> %s\n",cnf->tsvfile,buf1);      		
	      	cnf->tsvfile=strdup(buf1);		
	    

			if (strchr(verbose,'x'))
			{
	      	strcpy(buf1+(strlen(buf1)-4),".log");
	    	if (rename(cnf->logfile, buf1))    	 
	     		fprintf(stderr,"Warning: unable to rename the file %s -> %s\n",cnf->logfile,buf1);      	   		
	    	cnf->logfile=strdup(buf1);				     
	    	}
	    }
}

int processgraphfromfile(config *cnf)
{
	voxelbuf _vb;
	voxelbuf *vb=&_vb;

	int runstotal=0;
	int improvements=0;
	int lastimprovenentrun=0;
   	
    readxyz(cnf->inputfile, vb);    	
  

	graph g;
	g.globalstarttime = gettime();	

	int saved = 0;


#define NormalizeFittness	{ double ps = 0.0;\
		for (int i=0; i<pscnt; i++) ps+=allps[i]->fitness;\
		for (int i=0; i<pscnt; i++) allps[i]->fitness/=ps; }	

#define ResetFittness for (int i=0; i<pscnt; i++) if (allps[i]->fitness>0) allps[i]->fitness = 1.0;

	g.cpoollen=0;

	if (initgraph(&g,vb,cnf))
	{	

		greedylog("Graph contains only small components...\n");
		g.totaltime = gettime()-g.globalstarttime;
		
	}	
	else if (!cnf->checkonly) 
	{

		// ppgraph(&g,0,p);
		// printf("\n");
		// ppspace(&vs);

		g.localstarttime = gettime();	

		int mscore = g.minscore; // -1 if unitialized
		
		int curset = -1;
   	cnf->timeimproved = gettime(); // initialize 
		
		// set fitness
		for (int i=0; i<cnf->parsetlen; i++)
			cnf->parsets[i].fitness=1.0/cnf->parsetlen;
		
		long runimproved = 0;

		// Assign PSs to components (depends on conditions)
		int pscnt = 0;		
		int poolsize = 0;
		for (int i=0; i<g.complen; i++)
		{
			pscnt += initializecomponentPSs(g.comp[i],cnf);
			poolsize += g.comp[i]->initialps.repeats;
		}
				
		// prerpare pool of components		
		g.cpool = (component**)malloc(sizeof(component*)*poolsize);

		for (int cid=0; cid<g.complen; cid++)
		{
			component *src = g.comp[cid];
			src->active = true;
			g.cpool[g.cpoollen++] = src;			
			for (int cp=1; cp<src->initialps.repeats; cp++)
			{

				// todo: initialization
				component *comp = (component*)malloc(sizeof(component));
				*comp = *src; // copy

				comp->minscoreseparator = (voxelid*)malloc(sizeof(voxelid)*(comp->len+1));		
				memcpy (comp->minscoreseparator, src->minscoreseparator, sizeof(voxelid)*(comp->len+1));									
				comp->status = (statustype*)malloc(sizeof(statustype)*(comp->len+1));							
				memcpy (comp->status, src->status, sizeof(statustype)*(comp->len+1));

				comp->ngh = (ngharr*)malloc(sizeof(ngharr)*(comp->len+1));
				memcpy (comp->ngh, src->ngh, sizeof(ngharr)*(comp->len+1));
					
				// randomize neighbours
				for (int cur = 1; cur <= comp->len; ++cur)
					for (int i = comp->v[cur]->nghlen-1; i > 0; i--)
		    		{        
		        		int j = rand() % (i+1);  		        
		        		voxelid tmp = comp->ngh[cur][i];
		        		comp->ngh[cur][i]=comp->ngh[cur][j];
		        		comp->ngh[cur][j]=tmp;
		    		}
										
				g.cpool[g.cpoollen++] = comp;

				pscnt += initializecomponentPSs(comp,cnf);
				comp->active = true;
			}		 
		}



		parameters **allps = (parameters**)malloc(sizeof(parameters*)*(pscnt+1));

		// prepare all ps x comp array
		pscnt=0;
		for (int i=0; i<g.cpoollen; i++)
			for (int ps=0; ps<g.cpool[i]->parsetlen; ps++)			
				allps[pscnt++] = g.cpool[i]->parsets+ps;
		allps[pscnt]=0; // guard

		if (verbose_PSstats_s)
			for (int i=0; i<g.cpoollen; i++)
			{
				greedylog("initial: ");
				ppparameters(cnf,&(g.cpool[i]->initialps));
				greedylog("\n");	
			}

		if (verbose_PSstats_5)
		{		
			for (int i=0; i<g.complen; i++)
			{
				greedylog(">>>initial: ");
				ppparameters(cnf,&(g.comp[i]->initialps));
				greedylog("\n");	
				for (int ps=0; ps<g.comp[i]->parsetlen; ps++)			
				{
					greedylog(">PS: ");
					ppparameters(cnf,&(g.comp[i]->parsets[ps]));
					greedylog("\n");					
				}
			}
		}

		// run initial PS for every component		
		// greedylog("graph minscore=%d\n",g.minscore);
		if (g.minscore<0) g.minscore = g.easyplus;
		else g.tscore = g.minscore;
		
		// greedylog("graph minscore=%d tscore=%d\n",g.minscore, g.tscore);


		//initial run for the representants
		for (int i=0; i<g.complen; i++)
		{		
			component *comp = g.comp[i];
			parameters *curps = &comp->initialps;			
			processcomponentphase1(curps, cnf, runstotal);			
			runstotal++;
		}

		if (verbose_initialscores_0)
		{
			greedylog("%4d. minscore=%-5d time=%.3f", runstotal,
				g.minscore,gettime()-g.globalstarttime);

			if (strchr(verbose,'p'))
						greedylog(" file=%s",cnf->inputfile);						
			greedylog("\n");

		}
								
		// initial run for the rest
		for (int i=0; i<g.cpoollen; i++)
		{	

			component *comp = g.cpool[i];

			if (comp!=g.comp[comp->cid])
			{
				
				int prevscore = g.minscore;
				parameters *curps = &comp->initialps;			
				processcomponentphase1(curps, cnf, runstotal);			
				runstotal++;
				if (prevscore > g.minscore)
				{
					
					runimproved = runstotal;
					comp->timeimproved = cnf->timeimproved = gettime();
					improvements++;			
					lastimprovenentrun=runstotal;
					if (verbose_initialscores_0)
					{
						greedylog("%4d. minscore=%-5d time=%.3f", runstotal,
							g.minscore,gettime()-g.globalstarttime);

						if (strchr(verbose,'p'))
									greedylog(" file=%s",cnf->inputfile);						
						greedylog("\n");
					}
				}
			}
					
		}

#ifdef SCORE_CTRL_DEBUG
		ppscoreg(&g);
#endif		
		
		if (verbose_PSstats_s)
			greedylog("Components (pool) with PSs:\n");

		for (int i=0; i<pscnt; i++)
		{
			if (verbose_PSstats_s)
			{
				greedylog("%d. ",i);
				ppparameters(cnf,allps[i]);
				greedylog("\n");
			}
		}

		for (int i=0; i<pscnt; i++) allps[i]->fitness = 1.0;
		

		if (cnf->onecomponentoonly>=0)
		{
			for (int i=0; i<pscnt; i++) 
				if (allps[i]->comp->cid != cnf->onecomponentoonly) allps[i]->fitness=0;
		}

		NormalizeFittness;

		int activecomponents = g.cpoollen;

		double noimprscale = 1.0;

		double timeimproved = cnf->timeimproved;

		while (1)		
		{    				
			
			
			if ((cnf->noimprovementtimethreshold>0) && ((gettime()-timeimproved)>cnf->noimprovementtimethreshold)) 
			{			
					
					// try rejection algorithm 
					// reconstruct components
					// remove cnf->rejection worst components
					// and increase time		
					// if (verbose_scorepool_o)
					// {
					// 	printf("=====================before rejection====================\n");
					// 	printf("activecomponents=%d",activecomponents);
					// 	ppscoreg(&g,);
					// }	

				  if (activecomponents==g.complen) break;

					component *buf[g.cpoollen];
					int buflen;
					int minscorecnt=1;
					bool sthrejected = false;

					for (int cid=0; cid<g.complen; cid++)
					{
							// take the initial ps parameters
							parameters *initialps = &g.comp[cid]->initialps;

							if (!initialps->reducepool) continue;
														  
							buflen=1;
							for (int i=0; i<g.cpoollen; i++)
							{
								component *comp = g.cpool[i];
								if (!comp->active) continue;
								if (comp == g.comp[cid]) { 
									buf[0] = comp;
									continue; // optimal, should be at first pos.
								}									
								if (comp->cid==cid)
								{
									if (comp->minscore == g.comp[cid]->minscore) minscorecnt++;
									buf[buflen++] = comp;
								}
							}

							if (buflen==1) continue;	

							sthrejected=true;					
							// sort by minscores

							int rej=initialps->poolreduction_threshold*buflen;

							if (minscorecnt<buflen)
								qsort (buf+1, buflen-1, sizeof(component*), compminscores);		
							else rej=initialps->poolreduction_eqthreshold*buflen;								

							if (rej>=buflen-1) rej=buflen-1;
							if (rej<1) rej=1;						

							//printf("Rejection from %d. minscorecnt=%d buflen=%d\n",rej,minscorecnt,buflen);

							for (int i=rej; i<buflen; i++)
							{
								buf[i]->active = false;
															
						 		for (int ps=0; ps<buf[i]->parsetlen; ps++)			
					 				buf[i]->parsets[ps].fitness=0;			

					 			activecomponents--;
							}
				} // for (cid)

				if (!sthrejected) break; // no rejections
				
				// clean (remove non-active)
				int n=0;
				for (int i=0; i<g.cpoollen; i++)
				{
					component *comp = g.cpool[i];
					if (g.comp[comp->cid]==comp) g.cpool[n++]=comp;
					else 
						if (comp->active) 
							g.cpool[n++]=comp;
						else							
						{
							// clean
							free(comp->minscoreseparator);
							free(comp->status);
							free(comp->ngh);
							free(comp);
						}
				}
				g.cpoollen = n;


					
				if (verbose_scorepool_o)																
				{
					ppscoreg(&g,true,cnf);
				}
				
				// reset fitness
				
				if (cnf->poolreduction_resetfittness)
				{							
					ResetFittness;
				}

				NormalizeFittness;
				
				noimprscale = noimprscale*0.5;					

				// here time improved is faked (use cnf->timeimproved for the true time)
				timeimproved = gettime()-1.0*cnf->noimprovementtimethreshold*noimprscale; // reset improvennts								
				
						
			}	



			// draw curset			
			double p = 1.0*rand()/RAND_MAX; 
			if (p>=1.0) continue; // avoid error in the next while

			int i=0;
			while ((p-=allps[i]->fitness)>0) i++;  // carefull here with bugs due to float comp. 
			parameters *ps = allps[i];		

		
			int r=0;					
			g.localstarttime = gettime();	

			if ((cnf->globaltimelimit>0) && ((gettime()-g.globalstarttime)>cnf->globaltimelimit)) 
				break; // global time over

										
			// runs 
			while (1)
			{

				if (cnf->noimprovementrunthreshold > 0 && (runstotal-runimproved) > cnf->noimprovementrunthreshold)				
					break;
			
				if ((cnf->globaltimelimit>0) && ((gettime()-g.globalstarttime)>cnf->globaltimelimit)) 
						break; // time over
				
				if (ps->timelimit_T>0)
				{
					if ((gettime()-g.localstarttime)>ps->timelimit_T) 
						break; // time over
				} 

				if ((cnf->noimprovementtimethreshold>0) && ((gettime()-timeimproved)>cnf->noimprovementtimethreshold)) 				
					break; // time over
				
			
				if ((ps->runs_r>0) && (ps->runs_r==r)) break; // runlimit
				
				int prevscore = g.minscore;
								
				processcomponentx(ps, cnf, runstotal);	

				// greedylog("\nRS=%d %d g.minscore=%d \n",runstotal,bs,g.minscore);

				double oldfit= ps->fitness;
				if (prevscore > g.minscore)
				{
					// increase fitness
										
					ps->fitness+=0.25/pscnt;

					NormalizeFittness;									
					
					if (cnf->stoponscore>0)
						{ greedylog("%4d. minscore=%-5d stopscore=%.2f%% time=%.3f",runstotal,g.minscore,100.0*(g.minscore-cnf->stoponscore)/cnf->stoponscore,gettime()-g.globalstarttime); }
					else
						{ greedylog("%4d. minscore=%-5d time=%.3f",runstotal,g.minscore,gettime()-g.globalstarttime); }
								
					if (strchr(verbose,'p'))
						greedylog(" file=%s",cnf->inputfile);
				 
					
					greedylog("\n");
					runimproved = runstotal;
					timeimproved = ps->comp->timeimproved = cnf->timeimproved = gettime();
					improvements++;
					noimprscale = 1.0; // reset
					lastimprovenentrun = runstotal;

					

					if (strchr(verbose,'S') && verbose_writeoutputfiles_Q) // save after each iteration
					{					
						saveclusters(&g,cnf->tsvfile,cnf);	

						if (strchr(verbose,'x') || strchr(verbose,'X'))	
						{					
							saved = 1;
							savetoprojectdir(cnf, &g);			
						}						
					}		
				}
				else
				{
					// punish
					if (ps->fitness>0.001/pscnt)
					{
						ps->fitness-=0.001/pscnt;
					
						// normalize
						double ps = 0.0;
						for (int i=0; i<pscnt; i++) ps+=allps[i]->fitness;
						for (int i=0; i<pscnt; i++) allps[i]->fitness/=ps;	
					}
				}

				r++;
				runstotal++;
				if (verbose_PSstats_F)
					greedylog(" PS:%s fitness %.3f --> %.3f\n",ps->name,oldfit, ps->fitness);

				if (g.minscore==1) 				
					break; // optimum
				
			}

			if (g.minscore==1) 				
					break; // optimum

			if (g.minscore <= cnf->stoponscore)
					break; // stoponscore reached

			if (cnf->noimprovementrunthreshold > 0 && ((runstotal-runimproved) > cnf->noimprovementrunthreshold))				
				break;
		}

		if (verbose_PSstats_s)
		{
			greedylog("\n#%d\tsize=%-5d minscore=%-4d time=%.3f ",
				allps[0]->comp->cid,
				allps[0]->comp->len,
				allps[0]->comp->minscore,
				allps[0]->comp->totaltime);	
			double ss=0.0;

			for (int i=0; i<pscnt; i++)
			{				
				if (i>0 && allps[i-1]->comp!=allps[i]->comp) 
				{
					greedylog("totalfit=%.2f\n#%d\tsize=%-5d minscore=%-4d time=%.3f ",
						ss,
						allps[i]->comp->cid,
						allps[i]->comp->len,
						allps[i]->comp->minscore,
						allps[i]->comp->totaltime);	
					ss=0;
				}				
				ss+=allps[i]->fitness;
				greedylog("%s:%.4f ",allps[i]->name,allps[i]->fitness);		
			}
			greedylog("totalfit=%.3f\n",ss);	
		}

    
	  if (strchr(verbose,'t')) 
	  { 
	  		double tm = g.totaltime - (gettime() - cnf->timeimproved); // true time improved
	    	greedylog("Last improvement run: %d\n",lastimprovenentrun);	
	    	greedylog("Time of the last improvement: %.3f\n",tm);	
	    	greedylog("Total runs: %d\n",runstotal);	    		    	

	    	    	
	    	//ppimpstats(&g,p,r); 
	    	//greedylog("\n"); 
	  }


	} // if checkonly



	if (strchr(verbose,'u')) 
		regularitychecker(&g,cnf);

	if (!cnf->checkonly && verbose_writeoutputfiles_Q)
		saveclusters(&g,cnf->tsvfile,cnf);	


	g.totaltime = gettime()-g.globalstarttime;	

	int briefsaved = 0;

	if (!cnf->checkonly) 
	{
		greedylog("minscore:%d\n",g.minscore);
		greedylog("totaltime_sec:%.3f\n",g.totaltime);
		greedylog("%ld cluster insertions(s); %.3f clusters per sec.\n",
			clusterinsertions,
			clusterinsertions/g.totaltime);

		// if (cnf->brieftsv)
		// {
		//   	FILE *f = fopen(cnf->brieftsv,"w");
		//   	fprintf(f,"%s\t%d\t%.3f\t%d\t%d\n",cnf->inputfile,g.minscore,g.totaltime,runstotal,improvements);
		//   	fclose(f);
		//   	briefsaved=1;
		// }
	}




	if ((strchr(verbose,'x') || strchr(verbose,'X')) && verbose_writeoutputfiles_Q)
	{
		if (!saved)
			savetoprojectdir(cnf, &g);
	}
	
	if (verbose_writeoutputfiles_Q)
	{
		greedylog("outpufiles:%s",cnf->logfile);
		if (g.tsvcreated) greedylog(";%s",cnf->tsvfile);	
		if (briefsaved) greedylog(";%s",cnf->brieftsv);
		greedylog("\n");
	}	

	if (verbose_scorepool_o)
	{
		ppscoreg(&g,false,cnf);
	}

	if (cnf->brieftsv)
	{
	  	FILE *f = fopen(cnf->brieftsv,"w");		  	
	  	briefsaved=1;	
			fprintf(f,"%s\t%d\t%d\t%d\t%d\t%d\t%d\t%.1f\t%d\t%d\t%.1f\t%.3f\t%.4f\t%s\t%s\n",					
				cnf->projectname,
    		g.minscore,	    	
    		cnf->optk,
    		g.vlen,
    		g.complen,
    		g.complen+g.easycomplen,
    		runstotal,
    		g.totaltime,
    		improvements,
    		lastimprovenentrun,
    		g.totaltime - (gettime()-cnf->timeimproved),
    		clusterinsertions/1000000.0,
				clusterinsertions/g.totaltime/1000000.0,
				(verbose_writeoutputfiles_Q)?cnf->logfile:"",
				(verbose_writeoutputfiles_Q&&g.tsvcreated)?cnf->tsvfile:""
    		);	
			fclose(f);
	}

	return g.minscore;
}

int
argstocnf (int argc, char **argv, config *cnf)
{
 
  int bflag = 0;
  int i;

  int index;
  int c;

  initconfig(cnf);
  
  char *parameterstr = NULL;
  opterr = 0;

  char *continuedir=NULL;
  bool verbose_brieftsvheader = false;
  
  while ((c = getopt (argc, argv, "x:hk:v:t:p:l:f:i:cC:T:n:N:O:b:s:")) != -1)
    switch (c) 
	{
      	case 'h':
      		usage(cnf);
      		break;

      	case 'k':
        	cnf->optk = atoi(optarg); // todo: checking
        	break;

        case 's':
        	cnf->stoponscore = atoi(optarg); 
        	break;

        case 'O':
        	cnf->onecomponentoonly = atoi(optarg); // todo: checking
        	break;

        case 'n':
        	cnf->noimprovementrunthreshold = atoi(optarg); // todo: checking
        	break;

	      // global time limit
	      case 'T': 
	      {
			cnf->globaltimelimit=gettimestr(optarg);      
	      	cnf->globaltimelimitset=1;
	      	break;
	      }

	      // global ext threshold
	      case 'N': 
	      {
				cnf->noimprovementtimethreshold=gettimestr(optarg);           
	      		break;
	      }

     
     	case 'l': 
      	cnf->logfile = strdup(optarg);
      	FILE *f = fopen(optarg,"w");
      	if (!f)
      	{
      		fprintf(stderr,"Cannot open log file for writing.");
      		exit(-1);
      	}
      	break;

      case 'f': 
      	cnf->filesuffix=strdup(optarg);
      	break;
      
      case 'p': 
      	cnf->projectname=strdup(optarg);      	
      	break;

      case 'i': 
      	cnf->projectinfo=strdup(optarg);      	
      	break;

      case 't': 
      	cnf->tsvfile=strdup(optarg);
      	break;      	

      case 'b': 
      	cnf->brieftsv=strdup(optarg);
      	break;

	  case 'C':
	    continuedir=strdup(optarg);
	    break;


      case 'v':
      	verbose = strdup(optarg);

		verbose_ppstage1_1 = strchr(verbose,'1')!=NULL;
		verbose_ppstage2_2 = strchr(verbose,'2')!=NULL;
		verbose_ppscores_3 = strchr(verbose,'3')!=NULL;
		verbose_PSstats_s = strchr(verbose,'s')!=NULL;
		verbose_PSstats_5 = strchr(verbose,'5')!=NULL;
		verbose_PSstats_F = strchr(verbose,'F')!=NULL;
		verbose_initialscores_0 = strchr(verbose,'0')!=NULL;
		verbose_scoreafterrefill_4 = strchr(verbose,'4')!=NULL;;
		verbose_esteps_r = strchr(verbose,'r')!=NULL;
		verbose_forcewritingtsv_f=strchr(verbose,'f')!=NULL;
		verbose_writeoutputfiles_Q = !strchr(verbose,'Q');
  		verbose_supressstdout_q = strchr(verbose,'q')!=NULL;
  		verbose_clustersizes_C = strchr(verbose,'C')!=NULL;
  		verbose_graphprop_G = strchr(verbose,'G')!=NULL;
		verbose_ignoretrivial_i = strchr(verbose,'i')!=NULL; 	
		verbose_resamplingimprovements_R = strchr(verbose,'R')!=NULL; 	
		verbose_SmpStats_T = strchr(verbose,'T')!=NULL; 	
		verbose_brieftsvheader = strchr(verbose,'b')!=NULL; 	

      	break;


      case 'c':
      	cnf->checkonly = 1;
      	break;

      case 'x':
      	parameterstr = strdup(optarg);
      	break;

      default:
        fprintf(stderr,"Unrecognized option %c",c);
        usage(cnf);
        exit(-1);
      }

  if (verbose_brieftsvheader)
  {
  	//printf("Dataset\tScore\tKval\tVoxels\tNonTrivialComponents\tAllComponents\tTotalRuns(executedPSs)\tTotalTime\tScoreImprovements\tLastImprovementRun\tTimeofthelastImprovement\tMClustersInserted(MC)\tSpeed(MCpersec)\tLogFile\tClusteringFile\n");
  	printf("Dataset\tScore\tKval\tVoxels\tNonTrivialComponents\tAllComponents\tTotalRuns\tTotalTime\tScoreImprovements\tLastImprovementRun\tTimeofthelastImprovement\tMClustersInserted\tMCpersec\tLogFile\tClusteringFile\n");
  	exit(0);
  }

  if (parameterstr)
     readparameters(cnf,parameterstr);

  if (!cnf->randomseed)
  {
		struct timeval t;   
		gettimeofday(&t,NULL);
		cnf->randomseed = t.tv_usec * t.tv_sec * getpid();  		
  }

  srand((unsigned int)cnf->randomseed);

  char *file = NULL;
  if (optind<argc)
  	file = strdup(argv[optind]);  

  if (!preparecnf(cnf, continuedir, file))  	
  {	
  	fprintf(stderr,"Cannot determine input file!\n");  	
  	ppconfig(cnf,0);
	usage(cnf);	
  	exit(-1);
  }

  if (cnf->optk<0)
  	cnf->optk = findkval(cnf->inputfile);

  if (cnf->optk<0)  
  {
  	fprintf(stderr, "k value undefined (use -kNUM or embed kvalNUM or kNUM into the input file name.");
  	exit(-1);
  }

  configsummary(cnf,strchr(verbose,'P')!=NULL);	  		

  if (optind+1<argc)  
  	fprintf(stderr, "Warning: I can process just one file.\n"); 
  
  return 0;

}

#include "batch7.h"

/*
	inputxyzfilename - input file name
	kval - k value 
 	globaltimelimit (-T) - time limit in seconds; if <=0 - no global limit
 	noimprovementtimethreshold - max no improvement time threshold per blob in seconds; if <=0 no limit
*/

int 
kseparatorupperbound(
	char *inputxyzfilename,
	int kval,
	double globaltimelimit,
	double noimprovementtimethreshold
	)
{

// Typical first run of fgreedy with all stats and logs:
// 	  k72_z31_xyz_76.tsv 
// 	 -x batch7.cnf  
// 	-N1 
// 	-b stats/1.tsv 	
//     -pk72_z31_xyz_76 
//     -Ck72_z31_xyz_76 
//     -t /tmp/fgreedylogs/k72_z31_xyz_76.91238.1.tsv.tmp 
//     -l /tmp/fgreedylogs/k72_z31_xyz_76.91238.1.log.tmp 
//     -vtTxp 
// "
	config cnf;  
  	
  	char buf[200];

  	char **argv = (char **)malloc(sizeof(char*)*100);

  	int argc = 0;
  	argv[argc++]=strdup("fgreedy");
  	argv[argc++]=strdup(inputxyzfilename);
  	argv[argc++]=strdup("-x");
  	argv[argc++]=strdup(BATCH7CNF);

	argv[argc++]=strdup("-k");  	
	sprintf(buf,"%d",kval);
	argv[argc++]=strdup(buf);

  	if (globaltimelimit>0)
  	{
  		argv[argc++]=strdup("-T");  	
  		sprintf(buf,"%g",globaltimelimit);
  		argv[argc++]=strdup(buf);
  	}

  	if (noimprovementtimethreshold>0)
  	{
  		argv[argc++]=strdup("-N");  	
  		sprintf(buf,"%g",noimprovementtimethreshold);
  		argv[argc++]=strdup(buf);
  	}

  	argv[argc++]=strdup("-vQq"); // Q - don't write output files;  q - supress stdout

  	argstocnf(argc, argv, &cnf);

	return processgraphfromfile(&cnf);	
}


int
main (int argc, char **argv)
{	
  	// run simplified variant for testing kseparatorupperbound
  	// fgreedy @ k90.csv 90 0 10
  	if ((argc==6) && (argv[1][0]=='@'))
  	{
  		// printf("Testing kseparatorupperbound ... ");
  		// fflush(stdout);
  		// convert 4 args 
  		// todo check correctness
  		long separatorsize = kseparatorupperbound(argv[2],atoi(argv[3]),atof(argv[4]),atof(argv[5]));
  		printf("%ld\n",separatorsize);
  		exit(0);
  	}

  	config cnf;  

	argstocnf(argc, argv, &cnf);

	processgraphfromfile(&cnf);

	return 0;
}



