#!/bin/bash


for ref_amino_acid in amino_acids/*/?.txt; do

#	ref_amino_acid="amino_acids/A/A.txt"

	a1=$(echo "$ref_amino_acid" | sed 's/amino_acids\/.\///g ; s/.txt//g')
	a3=$(echo $a1 | sed -f a1_a3.sed)

	rm -fr amino_acids/$a1/alt_coordinates/
	mkdir amino_acids/$a1/alt_coordinates/

	mkdir amino_acids/$a1/alt_coordinates/1_SNPs/
	#touch amino_acids/$a1/alt_coordinates/SNPs/$a3\_SNPs.txt
 
	mkdir amino_acids/$a1/alt_coordinates/2_DNPs_pos1/
	mkdir amino_acids/$a1/alt_coordinates/3_DNPs_pos2/ #amino_acids/$a1/alt_coordinates/DNPs/pos_2/
#	touch amino_acids/$a1/alt_coordinates/DNPs/pos_1/$a3\_DNPs_pos1.txt
#	touch amino_acids/$a1/alt_coordinates/DNPs/pos_2/$a3\_DNPs_pos2.txt

	mkdir amino_acids/$a1/alt_coordinates/4_DSNPs/
#	touch amino_acids/$a1/alt_coordinates/DSNPs/$a3\_DSNPs.txt

	mkdir amino_acids/$a1/alt_coordinates/5_TNPs/
#	touch amino_acids/$a1/alt_coordinates/TNPs/$a3\_TNPs.txt

	echo "" > amino_acids/$a1/newline.txt #amino_acids/$a1/DNPs/pos_1/newline.txt amino_acids/$a1/DNPs/pos_2/newline.txt amino_acids/$a1/DSNPs/newline.txt amino_acids/$a1/TNPs/newline.txt

	# 1) SNPs

	k1=1
	while read ref_coordinates; do

		ACGT=(A C G T)
		AGCT=(A G C T)

		pos_1=${ref_coordinates:0:1}
		pos_2=${ref_coordinates:1:1}
		pos_3=${ref_coordinates:2:1}

		pos1_refgrp="${ACGT[$((pos_1-1))]}"
		pos2_refgrp="${ACGT[$((pos_2-1))]}"
		pos3_refgrp="${AGCT[$((pos_3-1))]}"

		codon="$pos1_refgrp$pos2_refgrp$pos3_refgrp"

		header="ref_$k1:"
		ref_codon="$a1"
		ref_codon+="_$k1[$codon]"

		echo "$header $ref_codon" > amino_acids/$a1/$a1$k1.txt

		if [ $k1 -eq 1 ]; then

			echo "$ref_codon" > amino_acids/$a1/$a3.txt

		else

			echo "$ref_codon" >> amino_acids/$a1/$a3.txt

		fi


		# ref_codon_ID: SNP alternates
		./bash_scripts/2_alt_coordinates/1_SNP_coordinates.sh $a1 $k1 $pos_1 $pos_2 $pos_3
		./bash_scripts/2_alt_coordinates/2_DNPandDSNP_coordinates.sh $a1 $k1 $pos_1 $pos_2 $pos_3
		./bash_scripts/2_alt_coordinates/3_TNP_coordinates.sh $a1 $k1 $pos_1 $pos_2 $pos_3
		
		rm amino_acids/$a1/$a1$k1.txt
		 k1=$((k1+1))

	done < $ref_amino_acid

	rm amino_acids/$a1/newline.txt

done

