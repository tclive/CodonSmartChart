#!/bin/bash


rm -rf predict/

mkdir predict/
mkdir predict/ref\&mech_alt/ #predict/mech&alt_ref predict/ref&alt_mech/ predict/mech_ref&alt/


#for ref_amino_acid in amino_acids/*/?.txt; do

        ref_amino_acid="amino_acids/S/S.txt"

        a1=$(echo "$ref_amino_acid" | sed 's/amino_acids\/.\///g ; s/.txt//g')

	echo "a1: $a1"

	#a1="A"
        a3=$(echo $a1 | sed -f a1_a3.sed)


	mkdir predict/ref\&mech_alt/$a3/

	k1=1
	while read ref_codon; do

		pos_1=$(echo "$ref_codon" | cut -c5)
		pos_2=$(echo "$ref_codon" | cut -c6)
		pos_3=$(echo "$ref_codon" | cut -c7)

	#	echo "./3_logistics.sh - pos_1: $pos_1  pos_2: $pos_2  pos_3: $pos_3"
		#echo "$a1 $k1 $pos_1 $pos_2 $pos_3"

		mkdir predict/ref\&mech_alt/$a3/$a1\_$k1/

	#	./bash_scripts/3_logistics/1_SNPs/1A_codonID_SNPs2.sh $a1 $k1 $pos_1 $pos_2 $pos_3
	#	./bash_scripts/3_logistics/2_DNPs_pos1/2A_codonID_DNPs_pos1.sh $a1 $k1 $pos_1 $pos_2 $pos_3
	#	./bash_scripts/3_logistics/3_DNPs_pos2/3A_codonID_DNPs_pos2.sh $a1 $k1 $pos_1 $pos_2 $pos_3
	#	./bash_scripts/3_logistics/4_DSNPs/4A_codonID_DSNPs.sh $a1 $k1 $pos_1 $pos_2 $pos_3
	#	./bash_scripts/3_logistics/5_TNPs/5A_codonID_TNPs.sh $a1 $k1 $pos_1 $pos_2 $pos_3

		k1=$((k1 + 1))

	done < amino_acids/$a1/$a3.txt

	mkdir predict/ref\&mech_alt/$a3/$a1\_X/

	./bash_scripts/3_logistics/1_SNPs/1B_codonGroup_SNPs5.sh $a1
#	./bash_scripts/3_logistics/2_DNPs_pos1/2B_codonGroup_DNPs_pos1.sh $a1
#	./bash_scripts/3_logistics/3_DNPs_pos2/3B_codonGroup_DNPs_pos2.sh $a1
#	./bash_scripts/3_logistics/4_DSNPs/4B_codonGroup_DSNPs.sh $a1
#	./bash_scripts/3_logistics/5_TNPs/5B_codonGroup_TNPs.sh $a1


#done
