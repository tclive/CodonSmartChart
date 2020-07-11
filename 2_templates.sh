#!/bin/bash

# first we're going to create a codon table and coordinate table... 
# the purpose is to enumerate each codon and to designate each codon to an amino acid
# then we find SNV's across columns (1st postion), rows (2nd position), and within blocks...

if [ -e codons.txt ]; then
	rm -f codons.txt 
fi

if [ -e coordinates.txt ]; then
	rm -f coordinates.txt
fi

#    _ _ _ _ _ _  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
#   |												|
#   | 					... 2nd position across x-axis ...			|
#   |	column = $pos_2						 				|
#   |   row = ($pos_1 - 1) * 4 + $pos_3								|
#   |												|
#   |			coordinates:			   codons:				|
#   |												|
#   |				1   2   3   4		 	 A   C   G   T			|
#   |			1 1    111|121|131|141		   A A	AAA|ACA|AGA|ATA			|
#   |			  2    112|122|132|142		     G	AAG|ACG|AGG|ATG			|
#   |			  3    113|123|133|143		     C	AAC|ACC|AGC|ATC			|
#   |			  4    114|124|134|144		     T	AAT|ACT|AGT|ATT			|
#   |												|
#   |	  ...		2 1    211|221|231|241		   C A	CAA|CCA|CGA|CTA			|
#   |	  1st		  2    212|222|232|242		     G	CAG|CCG|CGG|CTG			|
#   |	   &		  3    213|223|233|243		     C	CAC|CCC|CGC|CTC			|
#   |	  3rd		  4    214|224|234|244		     T	CAT|CCT|CGT|CTT			|
#   |	positions										|
#   |	  down		3 1    311|321|331|341		   G A	GAA|GCA|GGA|GTA			|
#   |	   y-		  2    312|322|332|342		     G	GAG|GCG|GGG|GTG			|
#   |	  axis		  3    313|323|333|343		     C	GAC|GCC|GGC|GTC			|
#   |	  ...		  4    314|324|334|344		     T	GAT|GCT|GGT|GTT			|
#   |												|
#   |			4 1    411|421|431|441		   T A	TAA|TCA|TGA|TTA			|
#   |			  2    412|422|432|442		     G	TAG|TCG|TGG|TTG			|
#   |			  3    413|423|433|443		     C	TAC|TCC|TGC|TTC			|
#   |			  4    414|424|434|444		     T	TAT|TCT|TGT|TTT			|
#   |												|
#   | _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _	|

#echo "let's make a codon chart, enumerated by coordinates where column number equals position_2 and row number is a function of positions 1 and 3 ( '(\$position_1 - 1) \* 0 + \$position_3 )... the charts are identical, except that for positions 1 and 2: 1=A, 2=C, 3=G, and 4=T but for position_3: 1=A, 2=G, 3=C, 4=T "

echo ""

for (( i = 1; i < 5 ; i++ )); do

	case $i in
	1)
		pos_1="A"
		;;
	2)
		pos_1="C"
		;;
	3)
		pos_1="G"
		;;
	4)
		pos_1="T"
		;;
	esac

	for (( k = 1; k < 5; k++ )); do

		case $k in
		1)
			pos_3="A"
			;;
		2)
			pos_3="G"
			;;
		3)
			pos_3="C"
			;;
		4)
			pos_3="T"
			;;
		esac

		for (( j=1; j < 5; j++ )); do

			case $j in
			1)
				pos_2="A"
				;;
			2)
				pos_2="C"
				;;
			3)
				pos_2="G"
				;;
			4)
				pos_2="T"
				;;
			esac

			echo $i$j$k >> "$j"_num.txt
			echo $pos_1$pos_2$pos_3 >> "$j"_al.txt

		done
	done
done
paste -d\| 1_num.txt 2_num.txt 3_num.txt 4_num.txt > coordinates.txt
paste -d\| 1_al.txt 2_al.txt 3_al.txt 4_al.txt > codons.txt
rm -f 1_*.txt 2_*.txt 3_*.txt 4_*.txt

echo "coordinate chart:"
cat coordinates.txt
echo ""

echo "codons chart:"
cat codons.txt
echo ""
