#!/bin/bash

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

k=1
cp codons.txt codon_chart.txt
cp coordinates.txt coordinates_chart.txt

rm -rf reference_charts/
mkdir reference_charts/

# make header and row numbers

#echo "Reference:" > header_columns.txt
echo "  " >> header_columns.txt

awk 'BEGIN { for (i = 1; i <= 16; ++i) print i }' > rows.txt
head -9 rows.txt | sed "s/$/ /g" > 9rows.txt
tail -n 7 rows.txt >> 9rows.txt && mv 9rows.txt rows.txt
cat rows.txt >> header_columns.txt && mv header_columns.txt rows.txt

#echo "" > header_1.txt
echo "   1    " >> header_1.txt

#echo "        " > header_2.txt
echo "   2    " >> header_2.txt

#echo "        " > header_3.txt
echo "   3    " >> header_3.txt

#echo "        " > header_4.txt
echo "   4    " >> header_4.txt


# make reference charts for each amino acid

# amino_acids/Val/V.txt

for file in amino_acids/?.txt; do

	a1=$(echo $file | sed 's/amino_acids\///g' | sed 's/\.txt//g')
	a3=$(echo $a1 | sed -f a1_a3.sed)
	echo $a3":"
	i=1
	
	var+=("$a1")
	cp codons.txt $a3.txt

	while IFS='\t' read -ra line; do
		pos_1=${line:0:1}
		pos_2=${line:1:1}
		pos_3=${line:2:1}
		row=$(( ($pos_1 - 1) * 4 + $pos_3 ))
		column=$pos_2

		echo $a1"_"$i
#		i=$((i+1))

		coordinates_from_txt=$(echo $line | sed 's/,//g')
		coordinates_from_chart=$(awk -v a=${row} -v b=${column} -F\| 'FNR == a {print $b}' coordinates.txt)

		echo "coordinates_from_txt: "$coordinates_from_txt

		echo "txt: "$line
		echo "chart: "$coordinates_from_chart
		if [ "$coordinates_from_txt" = "$coordinates_from_chart" ]; then
			echo "coordinates from "$a1".txt match those in coordinates_chart..."
		else
			echo "ERROR: coordinates in "$a1".txt don't match coordinates in chart..."
			break
		fi

		codon=$(awk -v a=${row} -v b=${column} -F\| 'FNR == a {print $b}' codons.txt)

		echo "and by extension, match their appropriate codon (\""$codon"\") in the codon_chart..."

		# codon_chart_array
		var+=("$codon")

		sed -i "" "s/$codon/$a1\_$i\[$codon\]/g" $a3.txt
		sed -i "" "s/$codon/$a1\_$i\[$codon\]/g" codon_chart.txt
		sed -i "" "s/$coordinates_from_txt/$a1\_$i\[$coordinates_from_txt\]/g" coordinates_chart.txt

		i=$((i+1))
		echo ""

		done<$file

	#ref_array
	var2=arr$k[@]

	if [ "$(echo ${var[@]})" = "$(echo ${!var2})" ]; then
		echo $a1" arrays match..."
		echo "from reference: "${!var2}
		echo "from codon_chart: "${var[@]}
	else
		echo "ERROR: arrays don't match..."
		echo "from reference: "${!var2}
		echo "from codon_chart: "${var[@]}
		break
	fi
	echo "position(s) on codon_chart --"

	var=()
	k=$((k+1))

	awk -v no="   .    " -F\| 'FNR>=1 {print (length($1)>3) ? $1 : no }' $a3.txt > 1.txt
	awk -v no="   .    " -F\| 'FNR>=1 {print (length($2)>3) ? $2 : no }' $a3.txt > 2.txt
	awk -v no="   .    " -F\| 'FNR>=1 {print (length($3)>3) ? $3 : no }' $a3.txt > 3.txt
	awk -v no="   .    " -F\| 'FNR>=1 {print (length($4)>3) ? $4 : no }' $a3.txt > 4.txt


	cp header_1.txt ref_1.txt
	cp header_2.txt ref_2.txt
	cp header_3.txt ref_3.txt
	cp header_4.txt ref_4.txt

	cat 1.txt >> ref_1.txt
	cat 2.txt >> ref_2.txt
	cat 3.txt >> ref_3.txt
	cat 4.txt >> ref_4.txt
	rm 1.txt 2.txt 3.txt 4.txt

	paste -d" " rows.txt ref_1.txt ref_2.txt ref_3.txt ref_4.txt > $a3.txt
	rm -f ref_1.txt ref_2.txt ref_3.txt ref_4.txt

	cat $a3.txt

	mv $a3.txt reference_charts/
	
	echo ""

	### temporary code (unless I decide I like it)...

	mkdir amino_acids/$a1/
	mv amino_acids/$a1.txt amino_acids/$a1/

	###

done

rm rows.txt header_1.txt header_2.txt header_3.txt header_4.txt

echo ""
echo "Final coordinate chart:"
cat coordinates_chart.txt
echo ""

echo "Final codon_chart:"
cat codon_chart.txt
echo ""

mkdir reference_charts/archive/
cp codon_chart.txt reference_charts/archive/
mv coordinates.txt coordinates_chart.txt codons.txt reference_charts/archive/
