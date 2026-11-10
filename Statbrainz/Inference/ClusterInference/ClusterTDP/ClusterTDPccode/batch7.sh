#!/bin/bash

FGRSRC=/home/gorecki/Dropbox/articles/20clustertdp/fMRI_crit_nodes/125_fgreedy


DATADIR=data
JOBS=8
GREEDYOPT=
fgreedy=fgreedy$HOSTNAME
tmplogs=/tmp/fgreedylogs
SCRIPT=$( basename $0 )
SCRIPTBN=$( basename $0 .sh )
REALPSCRIPT=$( realpath $0 )
REALDIR=$( dirname $REALPSCRIPT )
REALJOBSCRIPT=$REALDIR/_singlejob.sh
CONFIG=$( realpath $SCRIPTBN.cnf )
GREEDYSRC="$FGRSRC/fgreedy.c  $FGRSRC/pp.c  $FGRSRC/tools.c"
INDEX=index.tsv
tmplogs=/tmp/fgreedylogs
stopfile=errstop.log

SRCARGS="$*"

function prepfgreedy()
{
	if ! [[ -f fgreedy ]] || [[ fgreedy -nt $FGRSRC/fgreedy ]] 
	then
	 	gcc -std=gnu99 -O3 -o fgreedy $GREEDYSRC 
	fi
	FGREEDY=$( realpath fgreedy )
	[[ -f $FGREEDY ]] || { echo No fgreedy ; exit -1; }
}

function Usage()
{
    cat <<EOF

    -i DIR - initialize DIR with data, cnf and scripts;     			
    			if DIR/$DATADIR is not present data will be copied from current dir (if exists)
    			
    -e DIR - execute/continue project and save results into DIR; use -f to overwrite previous execution otherwise interupted execution is continued

    -E DIR - as above; after completion the DIR is renamed to DIR__SCORE (prev. score is discared if present in the dirname)

    -f - force to start new execution (previous are ignored)

    -j JOBSCNT - number of jobs in parallel (def. $JOBS)

    -R DIR - remove nonmin tsv and log files from datadirs

    -m - merge args directories to release dirs; make tgz and tsv files

    -S - shuffle jobs when sending to parallel

    -p DIR - info on the progress
		-P DIR - info on the progress; refresh when change occurs
		-M $MAIL - send mail when running jobs are decreasing
		-t - print info in tab separated format in -p instead of human readable form

		-c "SIDE,C1,C2,C3,LIMIT" - create cube_s*.tsv for estimating heuristic errors and initialize; note that index.tsv is updated therefore previous results may be invalid
			  SIDE - geneated small cubes of size 1,2,..,SIDE (kval=SIDE^3)
			  C1,C2,C3 - how many small cubes on X, Y and Z in a blob
			  LIMIT - maximum number of voxel in a blob
				$0 -c "5,5,5,5,10000"				

		-u - run datasets from cubetest only

		-C DIR - analyze heuristic errors based on DIR/stats.tsv 

		-V DIR - check if DIR/stats/*.tsv files are consistent with index.tsv
			$0 -V N500

    
  fgreedy options to be passed:
    -N noimprovementtimethreshold
    -T time
    -v addtional verbose suboptions
    -x CONFIG.cnf 

  Examples:
		$0 -e work60 -N60     # start execution 
		$0 -e work60 -N60     # continue execution only if interupted 
		$0 -e work60 -N60 -f  # force new execution (previous stats are removed)
  	
		$0 -E work60 -N60      # first run; dirname is changed		
		$0 -E work60__* -N60   # next runs 

		$0 -m work60__*        # merge and archive
		$0 -m 						     # make tgz/tsv files

		$0 -p DIR              # info on the progress
		$0 -P DIR              # info on the progress; refresh when change occurs


		$0 -E N500 -N500 -j50 -S    # neurovault processing with shuffling
		$0 -m N500__*               # merging results to release		

	Typical usage:
		$0 -i destdir
		$0 -c "10,10,10,10,20000"	# prep large test
		$0 -E work500 -N500   # execute
		$0 -m  								# merge to relase 
		$0 -C release* 				# make error report 



EOF
} 


[[ $HOSTNAME = amor ]] &&	JOBS=50	


if ! [[ "$*" ]]
then
	Usage
	exit
fi

set -- `getopt i:e:j:N:T:v:E:x:R:mfp:P:t:Sc:C:uV:M: $*`

CONTINUE=1

while [ "$1" != -- ]
do
    case $1 in
    	-i) INITDIR=$2; shift;;
			-e) EXECUTE=$2; shift;;
			-E) EXECUTE=$2; DIRSCORE=1; shift;;
			-m) MERGEDIR=$1; DIRSCORE=1;;
			-S) SHUFFLE=1;;

			-j) JOBS=$2; shift;;
			-f) CONTINUE=;;
			-R) REMOVENONMINFILES=$2; shift;;

			-x) CONFIG=$( realpath $2 ); shift;;
			-N) noimprovementtimethreshold=$2; GREEDYOPT="$GREEDYOPT -N$2"; shift;;
			-T) fgreedy_time=$2; GREEDYOPT="$GREEDYOPT -T$2"; shift;;
			-v) fgreedy_addverbose=$2; shift;;
			-p) PROGRESS=$2; shift;;
			-P) PROGRESS=$2; LOOPING=60; shift;;
			-t) TSVOUTPUT=$2; shift;;
			-c) cubetest="${2//,/ }";  shift;;
			-C) heurerroranalysis=$2;  shift;;
 			-u) cubetestonly=1;;
			-V) checkstatsdir=$2; shift;;
			-M) SENDPROGRESSMAIL=$2; shift;;
		
      esac
      shift   # next flag
done
shift   # skip --

ARGS="$*"


if [ "$HFLG" = 1 ] 
then
  Usage 
  if [ "$HFLG" = "" ] 
  then 
    exit -1 
  fi
fi

# make project with data, index.tsv and cnf files
# copy data from the current dir if data is not present
# index os sorted by size starting from the largests
if [[ $INITDIR ]]
then

	[[ -d $INITDIR ]] || mkdir -p $INITDIR

	if ! [[ -d $INITDIR/$DATADIR ]]
	then
		echo "No $DATADIR dir in $DIR. Trying to make copy."
		[[ -d $DATADIR ]] || { echo "No $DATADIR in current dir. Cannot initialize."; exit -1; }		
		[[ -L $DATADIR ]] || ln -s $( realpath $DATADIR) $INITDIR		
	fi

	cd $INITDIR

	prepfgreedy
	
	# cp $REALPSCRIPT $CONFIG .

	echo $REALPSCRIPT $CONFIG

	[[ -f $REALPSCRIPT ]] && ln -s $REALPSCRIPT
	[[ -f $REALJOBSCRIPT ]] && ln -s $REALJOBSCRIPT
	[[ -f $CONFIG ]] && ln -s $CONFIG 

	if ! [[ -f $CONFIG ]]
	then
		#echo OPT2 $( dirname $REALPSCRIPT) $( basename $CONFIG )
		ln -s $( dirname $REALPSCRIPT)/$( basename $CONFIG )
	fi

	echo $DATADIR

	[[ -d cubetest ]] || mkdir cubetest

	echo "Preparing index file and checking correctness of data"
		
	# prepare index file
	for file in $DATADIR/*.?sv cubetest/*.?sv
	do 

		[[ -f $file ]] || continue

		basenamedir=$( basename ${file::-4} )
		#datasetdir="$resultsdir"$basenamedir	
		#workdir=$tmplogs/$basenamedir
		[[ $2 = d ]] && mkdir -p $datasetdir				
		if ! fgreedy -c $file -vTq -l /tmp/x.log -b /tmp/$$.tsv
		then
			>&2 echo "Checking failed: fgreedy -c -vT $file"
			exit -1
		fi		
		set $( cat /tmp/$$.tsv )
		rm -f /tmp/$$.tsv
		kval=$3
		size=$4
		file=$( realpath $file )

		if [[ "$file" =~ "cube_s".* ]]; 
		then
  		cube=1
  	else
  		cube=0  		
	  fi
		echo -e "$kval\t$size\t$basenamedir\t$file\t$cube"
	done | sort -r -k2 -n > $INDEX

	echo "$( cat $INDEX | wc -l )" datasets



	exit $?
fi


############

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
LBLUE='\033[1;34m'
NC='\033[0m' # No Color
 
function initcubetest()
{

	set $*
	SIDE=$1
	C1=$2
	C2=$3
	C3=$4
	LIMIT=$5

	[[ -d cubetest ]] || mkdir cubetest

	# clean previous
	rm -f cubetest/cube_s*

	python3 << EOF  > cubetest.tsv
vx=[]
for s in range(1,$SIDE):
	for c1 in range(1,$C1):
		for c2 in range(c1,$C2):
			for c3 in range(c2,$C3):
				c1s=c1*(s+1)-1
				c2s=c2*(s+1)-1
				c3s=c3*(s+1)-1
				voxels=c1s*c2s*c3s
				pn=f"{c1}x{c2}x{c3}"
				pnvx=f"{c1s}x{c2s}x{c3s}"
				opt=voxels-c1*c2*c3*s*s*s
				k=s*s*s
				if opt>1 and voxels<$LIMIT: 
					print(f'cube_s{s}_c{c1}x{c2}x{c3}_C{pnvx}_v{voxels}_opt{opt}_kval{k}',s,c1,c2,c3,pn,pnvx,voxels,opt,k)
EOF

	cat cubetest.tsv | while read cubefile s c1 c2 c3 pn pnvx voxels opt k
	do		
		if ! fgreedy ":$pnvx" -k$k -t /tmp/$cubefile.tsv -T0.0000001
		then
			echo fgreedy error
			exit -1
		fi
		cat /tmp/$cubefile.tsv | cut -f1-3 > cubetest/$cubefile.tsv
		rm /tmp/$cubefile.tsv
	done


}



if [[ $checkstatsdir ]]
then
	if cd $checkstatsdir/stats;
	then 
		nl ../../index.tsv | while read n _ _ f _ 
		do 
			if [[ -f $n.tsv ]];  
				then 
					set $( cat $n.tsv ); 
					[[ $1 = $f ]] || { echo "$n $f $1 - wrong filenames"; exit -1; }
					echo PROCESSED $n $f $1 
				else
					echo WAITING $n $f $1 
				fi; 
		done
	fi
	exit
fi

[[ $cubetest ]] && initcubetest $cubetest


function gensummary()
{


	cd $RDIR > /dev/null
	TOTALSCORE=$1
	if [[ -f .minscore ]]
	then
		LMIN=$( cat .minscore )
		if [[ $LMIN -gt $TOTALSCORE ]]
			then
				echo $TOTALSCORE > .minscore
				echo -e "$LBLUE""Total score $TOTALSCORE improved from $LMIN $NC"
				[[ -f $TOTALSCORE.tsv ]] || ln -s stats.tsv $TOTALSCORE.tsv				
			else
				echo -e "$RED""Total score $TOTALSCORE (total minscore $LMIN)$NC"
			fi
	else	
		echo -e "$LBLUE""Total score $TOTALSCORE (first run) $NC"	
		echo $TOTALSCORE > .minscore
		[[ -f $TOTALSCORE.tsv ]] || ln -s stats.tsv $TOTALSCORE.tsv						
	fi	

	cd - > /dev/null

	if [[ $DIRSCORE ]]
	then
		SRC=${RDIR%%__*}"__"$TOTALSCORE

		# echo DIRSCORE $RDIR  $SRC $PWD
		[[ $SRC == $RDIR ]] || mv $RDIR $SRC  # move 
		RDIR=$SRC
	fi

}

function  getminscore()
{
	ls [0-9]*.tsv | grep -o -P "^\d+"  | sort -n | head -1		
}

function  getminfile()
{
  ls "$1"*.tsv -t -r | grep "^$1[^0-9]" | head -1
}

if [[ $heurerroranalysis ]]
then

	cd $heurerroranalysis

	echo -e "Side[S]\tCube\tBlob\tBlobSize\tOptScore\tKval\tScore\tTime" > cubetest.tsv

	if [[ -f scstats.tsv ]] 
		then 
			cat scstats.tsv | cut -f3-4 | grep "cube_s" | sed "s/[ _\t][ _\t]*/\t/g; s/^[ \t]*\|cube\|opt\|kval\|v\|s//g; s/^\t//" >> cubetest.tsv
		elif [[ -f stats.tsv ]] 
			then
				cat stats.tsv | cut -f1-2,8 | grep "cube_s" | sed "s/[ _\t][ _\t]*/\t/g; s/^[ \t]*\|cube\|opt\|kval\|v\|s//g; s/^\t//" >> cubetest.tsv			
		else
			echo "scstats.tsv or stats.tsv file expected in $heurerroranalysis"
			cat stats/*.tsv | cut -f1-2,8 | grep "cube_s" | sed "s/[ _\t][ _\t]*/\t/g; s/^[ \t]*\|cube\|opt\|kval\|v\|s//g; s/^\t//" >> cubetest.tsv						
		fi
	
	# cube    s2      c1x3x3  C2x8x8  v128    opt56   kval8   56
	cat cubetest.tsv

python3 << EOF
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme()

import pandas as pd

sns.set(font_scale = 0.5)
sns.set_style("dark")
# Load the example flights dataset and convert to long-form
cubedata = pd.read_csv("cubetest.tsv",sep="\t")
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)

cubedata["PrcMinDiff"] = 100*(cubedata["Score"]-cubedata["OptScore"])/cubedata["OptScore"]

cubedata = cubedata.drop_duplicates(subset=["Kval", "BlobSize"])

#title="OptCnt"
#title="PrcAvgDiff"
title="PrcMinDiff"

dt = cubedata.pivot( "Kval", "BlobSize", title)

# Draw a heatmap with the numeric values in each cell
f, ax = plt.subplots(figsize=(100, 7))
sns.heatmap(dt, annot=True, fmt=".2f", linewidths=0, ax=ax)
plt.savefig(f"{title}.pdf")
print(f"{title}.pdf created in $heurerroranalysis")
#plt.show()
EOF

exit 
fi


if [[ $MERGEDIR ]]
then	
	SRCDIRS=$ARGS

	RDIR=$( echo release* )

	if ! [[ -d $RDIR ]]; then mkdir release; RDIR=release; fi
	
	#echo $RDIR

	[[ -d $RDIR ]] || { echo no $RDIR; exit -1; }
	[[ -f $INDEX ]] || { echo "No index file"; exit -1; }

	fgreedy=$( realpath fgreedy )

	echo Source directories $SRCDIRS

	rm -f $RDIR/scstats.tsv
	touch $RDIR/scstats.tsv

	cat $INDEX | nl | while read id k s b f cube
	do

			[[ -d $RDIR/$b ]] || mkdir -p $RDIR/$b


 			if cd $RDIR/$b >/dev/null
	 		then
	 				if ! ls *.tsv 2> /dev/null
					then				
						MINFILE=dummy				
					else			
						MINSCORE=$( getminscore )
						MINSCORESRC=$MINSCORE
						MINFILE=$( getminfile $MINSCORE )
						MINFILESRC=$MINFILE
						MINFILE=$( realpath $MINFILE )
						echo -n $( basename $f) $MINSCORE ' Cands: ' 

						if ! $fgreedy -c $MINFILE -k$k -vq > /dev/null
						then
							echo $MINFILE check error
							exit -1
						fi
					fi	 			
	 	
	 				#echo $MINFILE
		 			cd - >/dev/null		
		 			NEWFILE=

		 			for d in $SRCDIRS 
					do
						[[ -d $d/$b ]] || continue

						if ! ls $d/$b/*.?sv 2> /dev/null > /dev/null; then echo No tsv in $d; continue; fi

						cd $d/$b > /dev/null

						MINSCORE2=$( getminscore )
						MINFILE2=$( getminfile $MINSCORE2 )
												
						if ! $fgreedy -c $MINFILE2 -k$k > /dev/null
						then
							echo $MINFILE2 check error
							exit -1
						fi

						if [[ $MINFILE = dummy ]] || [[ $MINSCORE2 -lt $MINSCORE ]] 
						then
							MINSCORE=$MINSCORE2
							MINFILE=$( realpath $MINFILE2 )
							echo -e "  "$BLUE better $MINSCORE $MINFILE $NC
							NEWFILE=1
						fi						
						cd - > /dev/null
					done

					# store new file
					# scstats format:
					# Score\tTsvScoreFile\tDirName\tScore
					if [[ $NEWFILE ]]
					then
						(( dif=MINSCORESRC - MINSCORE ))
						echo -e "$RED   +"$dif $MINSCORE "-->" $MINSCORESRC $file $NC
						cp $MINFILE $RDIR/$b/$MINSCORE.tsv								

						echo -e "$MINSCORE\t$b/$MINSCORE.tsv\t$b\t$MINSCORE" >> $RDIR/scstats.tsv
						
					else
						[[ $MINFILE == dummy ]] && continue

						if ! [[ $MINFILESRC = $MINSCORE.tsv ]]		
						then
							mv $MINFILE $RDIR/$b/$MINSCORE.tsv
						fi
						echo -e "$MINSCORE\t$b/$MINSCORE.tsv\t$b\t$MINSCORE" >> $RDIR/scstats.tsv

					fi

			else
				echo cannot cd $datasetdir
				exit -1 
			fi

#		gensummary $TOTALSCORE
	done

	# cleaning	
	$0 -R $RDIR &

	[[ $( cat $RDIR/scstats.tsv | wc -l  ) = $( cat $INDEX | wc -l ) ]] || { echo "Data incomplete in $RDIR"; exit -1; }

	# extract non-cube data
	cat $RDIR/scstats.tsv | grep -v "cube_s[1-9]" > $RDIR/dtstats.tsv 

	TOTALSCORE=$( cut -f1 $RDIR/dtstats.tsv | paste -sd+ - | bc )

	# make archive
	cut -f2 $RDIR/dtstats.tsv > /tmp/$$.log
	
	cd $RDIR >/dev/null
	tar czf $TOTALSCORE.tgz -T /tmp/$$.log &&	cut -f3-4 dtstats.tsv > $TOTALSCORE.tsv && rm /tmp/$$.log && echo $RDIR/$TOTALSCORE.tgz and .tsv created 
	
	cd - >/dev/null
	gensummary $TOTALSCORE
	
	wait

	exit

fi


# remove non min files
# cleaning
if [[ $REMOVENONMINFILES ]]
then	
	RDIR=$( realpath $REMOVENONMINFILES )

	[[ -d $RDIR ]] || { echo "No $RDIR"; exit -1; }
	
	[[ -f $INDEX ]] || { echo "No index file"; exit -1; }

	cat $INDEX | nl | while read id k s b f cube
	do		
		if cd $RDIR/$b >/dev/null
		then
			MINSCORE=$( ls [0-9]*.tsv | grep -o -P "^\d+"  | sort -n | head -1 )
			MINFILE=$( ls "$MINSCORE"*.tsv -t -r | grep "^$MINSCORE[^0-9]" | head -1 )
			MINFILES=$( ls "$MINSCORE"*.tsv -t -r | grep "^$MINSCORE[^0-9]" )

			for i in *.tsv 
			do
				if [[ $i == $MINFILE ]]; 
					then 
						continue; 
				else
					rm -f $i fgreedy.log $( basename $i .tsv ).log
				fi
			done
			cd -  >/dev/null
		fi
	done 2>/dev/null 
	exit
fi


function prtime()  	
{
	secs=$( printf "%.0f" $( tr "." "," <<< $1 ) )

	if [[ $secs -gt 86400 ]]
		then
			printf '%dd:%02dh:%02dm:%02ds\n' $(echo -e "$secs/86400\n$secs%86400/3600\n$secs%3600/60\n$secs%60"| bc)
		elif [[ $secs -gt 3600 ]]
			then
				printf '%dh:%02dm:%02ds\n' $(echo -e "$secs/3600\n$secs%3600/60\n$secs%60"| bc)
		elif [[ $secs -gt 60 ]]
			then
				printf '%02dm:%02ds\n' $(echo -e "$secs/60\n$secs%60"| bc)
		else 
			printf '%02ds\n' $(echo -e "$secs"| bc)
	fi
}


# execute whole dataset and save to dir
if [[ $EXECUTE ]]
then


	RDIR=$EXECUTE

	echo Execute dataset in $RDIR	

	[[ -f $INDEX ]] || { echo "Dir uninitialized. Run with -i DIR from some source dir";
		exit -1; }
	[[ -d $RDIR ]] || mkdir -p $RDIR
	[[ -d $RDIR ]] || { echo "No $RDIR"; exit -1; }

	STARTTIME=$( date +%s )

	RDIR=$( realpath $EXECUTE )	
	INDEX=$( realpath $INDEX )

	[[ -d $RDIR ]] || mkdir -p $RDIR

	cat $CONFIG > $RDIR/$(basename $CONFIG) # for reference

	SINGLEJOBSCRIPT=$(realpath _singlejob.sh )

	cd $RDIR

	echo $( date ) $SRCARGS >> $RDIR/batch7.log

	echo $JOBS > $RDIR/.jobs

	echo fgreedy preparation

	prepfgreedy

	rm -f $stopfile
	mkdir -p $tmplogs

	rm -f stats.tsv

	if ! [[ $CONTINUE ]]
	then
		mv stats	$( date -Is )	
	fi
	
	mkdir -p stats

	echo Edit $( realpath .jobs ) to change the number of jobs

	echo Starting parallel

	export SHELL=$(type -p bash)
	export RED GREEN YELLOW LBLUE NC
	export tmplogs stopfile CONTINUE cubetestonly CONFIG  FGREEDY GREEDYOPT INDEX fgreedy_addverbose

	cat $INDEX | nl | if [[ $SHUFFLE ]]; then shuf; else cat; fi | parallel -u -j .jobs $SINGLEJOBSCRIPT

	echo "Merging stats..."

	cat $INDEX | nl | while read id k s b f cube; 
	do 
		[[ -f stats/$id.tsv ]] || { >&2 echo -e "\n$YELLOW $id. $f is unfinished...; to continue execute again; use -f to start over $NC"; exit -1; }				
		sort -k2 -n stats/$id.tsv | head -1
	done | tr " " "\t" >> stats.tsv

	if ! [[ $( cat stats.tsv | wc -l  ) = $( cat $INDEX | wc -l ) ]]
		then
			echo Stats lines $( cat stats.tsv | wc -l  )
			echo Expected $( cat $INDEX | wc -l )
			exit -1
		fi
	
	# echo "Merging stats..."
	TOTALSCORE=$( cat stats.tsv | grep -v "cube_s" | cut -f2 | paste -sd+ - | bc )

	fgreedy -vb > stats/header.tsv

	cd - >/dev/null
	gensummary $TOTALSCORE
	echo $RDIR completed

	ENDTIME=$( date +%s )
	bc <<< "$ENDTIME-$STARTTIME" > $RDIR/.lastruntime

	# completness stats
	$0 -p $(basename $RDIR) -j $JOBS

	exit 0
fi

# progress information

if [[ $PROGRESS ]]
then

	RDIR=$( realpath $PROGRESS )
	ALL=$( cat $INDEX | wc -l )
	PREVINFO=

	dstats=$RDIR/stats
	(( HALFJOBS=JOBS/2 ))

	 
	CUBEALL=$( grep cube_s $INDEX | wc -l )

	while true
	do 		

		[[ -d $RDIR ]] || { echo No $RDIR; exit -1; }
		[[ -d $dstats ]] || { echo No $dstats dir; exit -1; }

		if [[ $PREVINFO ]]; 
			then 
				[[ $LOOPING ]] || break; # single
				sleep 60;  
			fi

		PREVCOMPLETED=$COMPLETED

		#comp Done using stats
		if test -n "$(find $dstats -maxdepth 1 -name '[1-9]*.tsv' -print -quit)"
		then		
			#echo $dstats
			#COMPLETED=$( ls $dstats/[1-9]*.tsv | wc -l ) # TODO: find 
			COMPLETED=$( find $dstats -name '[1-9]*.tsv' | wc -l )  
		else
			COMPLETED=0
		fi

		# comp running
		PIDS=$( ps -u $USER | grep fgreedy  | while read a b; do echo $a; done )
		cnt=0
		LST=$( for p in $PIDS
		do
			ps -q $p -eo args | grep $RDIR/fgreedy | grep -o "\-p[^ ]*"  | sed 's/^-p//g'
			(( cnt++ ))
		done )
		RUNNING=$(wc -w <<< $LST)

		# unprocessed
		(( UNP=ALL-COMPLETED-RUNNING ))

		# cube test completed
		# CUBECOMPLETED=$( grep cube_s $dstats/*.tsv  | wc -l ) # TODO: find
		cd $dstats && CUBECOMPLETED=$( grep cube_s *.tsv  | wc -l ) && cd - # TODO: find
		CURINFO="Running:$RUNNING Completed:$COMPLETED Remaining:$UNP CubeTestCompleted:$CUBECOMPLETED CubeTestAll:$CUBEALL All:$ALL"

		# no change in info - skip printing
		[[ $CURINFO == $PREVINFO ]] && continue

		echo $UNP  $RUNNING  $SENDPROGRESSMAIL $HALFJOBS $$ 

		# send progress mail in case when jobs are dropping
		if [[ $UNP -gt $RUNNING ]] && [[ $SENDPROGRESSMAIL ]] && [[ $RUNNING -gt 0 ]] && [[ $RUNNING -lt $HALFJOBS ]]
		then
			mail -s "$0 processing" $SENDPROGRESSMAIL << EOF
			$CURINFO			
			From=$$
EOF
			echo Mail to $SENDPROGRESSMAIL sent

			HALFJOBS=$RUNNING

			if [[ $HALFJOBS -gt 5 ]] 
				then 
					(( HALFJOBS=HALFJOBS-5 ))			
			else
				(( HALFJOBS=HALFJOBS-1 ))			
			fi
				
		fi

		# send completeness mail
		if [[ $UNP = 0 ]] && [[ $SENDPROGRESSMAIL ]] && [[ $RUNNING = 0 ]]
		then
			mail -s "$0 $RDIR Completed" $SENDPROGRESSMAIL << EOF
			$CURINFO			
			From=$$
EOF

		fi
		


		if [[ $PREVCOMPLETED ]] && [[ $PREVCOMPLETED != $COMPLETED ]]
		then
			(( DIFF=COMPLETED-PREVCOMPLETED ))
			echo -n -e "$LBLUE +$DIFF $NC"
		fi
		PREVCOMPLETED=$COMPLETED

		echo -e "$YELLOW"Dir:$(basename $RDIR) $RED$( date -u )$NC
		echo $CURINFO

		PREVINFO=$CURINFO

		[[ $COMPLETED = 0 ]] && continue

		find $dstats -maxdepth 1 -name '[1-9]*.tsv' | xargs cat > /tmp/$$.tsv.log

		Secs=$( cat /tmp/$$.tsv.log  | cut -f8 |  paste -sd+ - | bc )

		echo "Sum of computation times (sequential): " $( prtime $Secs )
		SecsPar=$( bc <<< "scale=0; $Secs/$JOBS" )

		echo "Sum of computation times (parallel -j$JOBS): " $( prtime $SecsPar )
		
		
		# if [[ -f $RDIR/.lastruntime ]]
		# then
		# 	LRT=$(cat $RDIR/.lastruntime) 
		# 	echo "Last runtime (parallel): " $( prtime $LRT )
		# 	SPEEDUP=$( bc <<< "scale=2; $Secs/$LRT" ) 
		# 	echo "Speed up (seq/par): "  $SPEEDUP
		# fi


		SHORT=$( cat /tmp/$$.tsv.log  | cut -f8 | sort -k1 -n | head -1 )
		LONG=$( cat /tmp/$$.tsv.log  | cut -f8 | sort -k1 -n | tail -1 )
		AVG=$( bc <<< "scale=2; $Secs/$COMPLETED" )

		echo "Max dataset running time: " $( prtime $LONG )
		echo "Avg dataset running time: " $( prtime $AVG )
		echo "Min dataset running time: " $( prtime $SHORT )

		if [[ $TSVOUTPUT ]]
		then
			echo -e "$RDIR\t$RUNNING\t$COMPLETED\t$UNP\t$ALL\t$Secs\t$Long\t$AVG\t$SHORT"	>> $TSVOUTPUT	
		fi


		[[ $ALL == $COMPLETED ]] && break # nothing left
		
		LEFTSEQ=$( bc <<< "scale=0; $AVG*($UNP+$RUNNING*0.5)" )
		LEFTPAR=$( bc <<< "scale=0; $LEFTSEQ/$JOBS" )

		echo "Time left (sequential): " $( prtime $LEFTSEQ )
		echo "Time left using -j$JOBS (parallel): " $( prtime $LEFTPAR )

		#last 100 average
		FL=$( ls -t -r $dstats/*.tsv | tail -100 )		
		LEN=$( echo $FL | wc -w )

		[[ $LEN == $COMPLETED ]] && continue  # skip

		Secs=$( cat $FL | cut -f8 |  paste -sd+ - | bc )
		AVG=$( bc <<< "scale=2; $Secs/$LEN" )		

		LEFTSEQ=$( bc <<< "scale=0; $AVG*($UNP+$RUNNING*0.5)" )
		LEFTPAR=$( bc <<< "scale=0; $LEFTSEQ/$JOBS" )
		echo "Avg. time of the last $LEN processes:" $( prtime $AVG ) 		
		echo "Time left seq/par using last $LEN processes:" $( prtime $LEFTSEQ ) "/" $( prtime $LEFTPAR )
		

	done



fi