#!/bin/bash

rm -fr amino_acids/
mkdir amino_acids/

arr1=("A" "GCA" "GCG" "GCC" "GCT")
arr2=("C" "TGC" "TGT")
arr3=("D" "GAC" "GAT")
arr4=("E" "GAA" "GAG")
arr5=("F" "TTC" "TTT")
arr6=("G" "GGA" "GGG" "GGC" "GGT")
arr7=("H" "CAC" "CAT")
arr8=("I" "ATA" "ATC" "ATT")
arr9=("K" "AAA" "AAG")
arr10=("L" "CTA" "CTG" "CTC" "CTT" "TTA" "TTG")
arr11=("M" "ATG")
arr12=("N" "AAC" "AAT")
arr13=("P" "CCA" "CCG" "CCC" "CCT")
arr14=("Q" "CAA" "CAG")
arr15=("R" "AGA" "AGG" "CGA" "CGG" "CGC" "CGT")
arr16=("S" "AGC" "AGT" "TCA" "TCG" "TCC" "TCT")
arr17=("T" "ACA" "ACG" "ACC" "ACT")
arr18=("V" "GTA" "GTG" "GTC" "GTT")
arr19=("W" "TGG")
arr20=("X" "TAA" "TAG" "TGA")
arr21=("Y" "TAC" "TAT")


# Create ref_codon coordinate files

#rm -f A.txt D.txt N.txt R.txt C.txt Q.txt E.txt G.txt H.txt I.txt L.txt K.txt M.txt F.txt P.txt S.txt X.txt T.txt W.txt Y.txt V.txt

for j in {1..21}; do
	n="arr$j[@]"
	arr=("${!n}")
	for (( k = 0; k < ${#arr[@]} ; k++ )); do
		if [[ $k -eq 0 ]]; then
			touch $arr.txt
			continue
		else
			codon="${arr[$k]}"
			pos_1=${codon:0:1}
			pos_2=${codon:1:1}
			pos_3=${codon:2:1}

			case $pos_1 in
			A)
				pos_1=1
				;;
			C)
				pos_1=2
				;;
			G)
				pos_1=3
				;;
			T)
				pos_1=4
				;;
			esac

			case $pos_2 in
			A)
				pos_2=1
				;;
			C)
				pos_2=2
				;;
			G)
				pos_2=3
				;;
			T)
				pos_2=4
				;;
			esac

			case $pos_3 in
			A)
				pos_3=1
				;;
			G)
				pos_3=2
				;;
			C)
				pos_3=3
				;;
			T)
				pos_3=4
				;;
			esac

			echo $pos_1$pos_2$pos_3 >> $arr.txt
		fi
	done

	a3=$(echo "$arr" | sed -f a1_a3.sed)

#	if [ ! -d amino_acids ]; then
#		mkdir amino_acids/
#	fi

#	if [ ! -d amino_acids/$a3 ]; then
#		mkdir amino_acids/$a3/
#	fi

#	echo "$a3"

	#mkdir amino_acids/$a3/
	mv $arr.txt amino_acids/
done
