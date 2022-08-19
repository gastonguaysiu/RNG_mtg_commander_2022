#!/bin/bash

# building a mtg mana probability distribution

start=`date +%s`

sim=0
sim_goal=10000

turn4_deploy=0
turn5_deploy=0
turn6_deploy=0
turn7_deploy=0
turn8p_deploy=0

muliganC1=0
muliganC2=0
muliganC3=0

first_blood=0
mana_waste=0

############################################################

while (( $sim < $sim_goal)); do

reset=2

turn=-1
muligan=0
hand=0 #0 for unaccepted, 1 for accepter

mana_s=0
haste_s=0
perma_haste=0

goblin=0
land_drop=0

# 1:land, 2:shock
scry=0

mana=0
commander=0
c_sick=0
x=0
y=0

while (( $goblin < 16 )); do
  ((turn++))

    # we are in the draw step
    if (( $turn == 0 )); then
    
      while (( $hand < 1 )); do
        
        # reset when starting a game and
        if (( $reset > 0 ));then
          
          # if (( $reset == 1 )); then
          # echo "discarding $hmana mana, muligan $muligan"
          # echo ""
          # fi
          
          reset=0
          library=99
          count=0
          
          lands=29
          dlands=3
          shock=3
          sol=1
          RCC2=4 # 4 colored & 4 non-colored exist that don't come in tapped
          
          spirit=1
          ritual=1
          hymn=1
          
          GCC0=1
          first=6
          motivator=1
          mass=1
          oCC1=$((13 - $first - $motivator - $mass))
          GCC2=6
          G2=3
          oCC2=$((20 - $GCC2 - $G2))
          GCC3=6
          GhCC3=2
          G3=1
          oCC3=$((14 - $GCC3 - $GhCC3 - $G3))
          GCC4=1
          G4=1
          oCC4=$((5 - $GCC4 - $G4))
          GCC5=1
          G5=2
          oCC5=$((3 - $GCC5 - $G5))
          haste=0
          
          mk1a=$(($lands + $dlands))
          mk1b=$(($mk1a + $shock))
          mk1c=$(($mk1b + $sol))
          mk1d=$(($mk1c + $spirit))
          mk1e=$(($mk1e + $ritual + $hymn))
          mk2=$(($mk1d + $RCC2))
          
          tab0=$(($mk2 + $GCC0))
          tab1a=$(($tab0 + $first))
          tab1b=$(($tab1a + $motivator + $mass))
          tab1x=$(($tab1b + $oCC1))
          tab2a=$(($tab1x + $G2))
          tab2b=$(($tab2a + $GCC2))
          tab2x=$(($tab2b + $oCC2))
          tab3a=$(($tab2x + $GCC3))
          tab3b=$(($tab3a + $GhCC3 + $G3))
          tab3x=$(($tab3b + $oCC3))
          tab4a=$(($tab3x + $GCC4 + $G4))
          tab4x=$(($tab4a + $oCC4))
          tab5a=$(($tab4x + $G5 + $GCC5))
          tab5x=$(($tab5a + $oCC5))
          tabx=$(($tab5x + $haste))
          other=$(($library - $tabx))
          
          hlands=0
          hdlands=0
          hshock=0
          hsol=0
          hRCC2=0
          hmana=0
          
          hspirit=0
          hritual=0
          hhymn=0
          
          hGCC0=0
          
          hfirst=0
          hmotivator=0
          hmass=0
          hoCC1=0
          
          hGCC2=0
          hG2=0
          hoCC2=0
          
          hGCC3=0
          hGhCC3=0
          hG3=0
          hoCC3=0
          
          hGCC4=0
          hG4=0
          hoCC4=0
          
          hGCC5=0
          hG5=0
          hoCC5=0
          
          hhaste=0
          hother=0
        fi
        
        while (( count < 7 )); do
          ((count++))
          # Generate the random number, upper bound is library size to draw a card
          randomN=$((1 + $RANDOM % $library))
          
          if (( $randomN <= $lands )); then
            ((hlands++))
            ((lands--))
          elif (( $randomN > $lands && $randomN <= $mk1a )); then
            ((hdlands++))
            ((dlands--))
          elif (( $randomN > $mk1a && $randomN <= $mk1b )); then
            ((hshock++))
            ((shock--))
          elif (( $randomN > $mk1b && $randomN <= $mk1c )); then
            ((hsol++))
            ((sol--))
          elif (( $randomN > $mk1c && $randomN == $mk1d && $spirit == 1 )); then
            ((hspirit++))
            ((spirit--))
          elif (( $randomN > $mk1d && $randomN == $mk1e && $ritual == 1 )); then
            ((hritual++))
            ((ritual--))
          elif (( $randomN > $mk1d && $randomN <= $mk1e )); then
            ((hhymn++))
            ((hymn--))
          elif (( $randomN > $mk1e && $randomN <= $mk2 )); then
            ((hRCC2++))
            ((RCC2--))
          elif (( $randomN > $mk2 && $randomN <= $tab0 )); then
            ((hGCC0++))
            ((GCC0--))
          elif (( $randomN > $tab0 && $randomN <= $tab1a )); then
            ((hfirst++))
            ((first--))
          elif (( $randomN > $tab1a && $randomN == $tab1b && $motivator == 1 )); then
            ((hmotivator++))
            ((motivator--))
          elif (( $randomN > $tab1a && $randomN <= $tab1b )); then
            ((hmass++))
            ((mass--))
          elif (( $randomN > $tab1b && $randomN <= $tab1x )); then
            ((hoCC1++))
            ((oCC1--))
          elif (( $randomN > $tab1x && $randomN <= $tab2a )); then
            ((hG2++))
            ((G2--))
          elif (( $randomN > $tab2a && $randomN <= $tab2b )); then
            ((hGCC2++))
            ((GCC2--))
          elif (( $randomN > $tab2b && $randomN <= $tab2x )); then
            ((hoCC2++))
            ((oCC2--))
          elif (( $randomN > $tab2x && $randomN <= $tab3a )); then
            ((hGCC3++))
            ((GCC3--))
          elif (( $randomN > $tab3a && $randomN == $tab3b && $G3 == 1 )); then
            ((hG3++))
            ((G3--))
          elif (( $randomN > $tab3a && $randomN <= $tab3b )); then
            ((hGhCC3++))
            ((GhCC3--))
          elif (( $randomN > $tab3b && $randomN <= $tab3x )); then
            ((hoCC3++))
            ((oCC3--))
          elif (( $randomN > $tab3x && $randomN == $tab4a && $G4 == 1 )); then
            ((hG4++))
            ((G4--))
          elif (( $randomN > $tab3x && $randomN <= $tab4a )); then
            ((hGCC4++))
            ((GCC4--))
          elif (( $randomN > $tab4a && $randomN <= $tab4x )); then
            ((hoCC4++))
            ((oCC4--))
          elif (( $randomN > $tab4x && $randomN == $tab5a && $GCC5 == 1 )); then
            ((hGCC5++))
            ((GCC5--))
          elif (( $randomN > $tab4x && $randomN <= $tab5a )); then
            ((hG5++))
            ((G5--))
          elif (( $randomN > $tab5a && $randomN <= $tab5x )); then
            ((hoCC5++))
            ((oCC5--))
          elif (( $randomN > $tab4x && $randomN <= $tabx )); then
            ((hhaste++))
            ((haste--))
          else # (( $randomN > $mk1b && $randomN <= $tab1 )); then
            ((hother++))
            ((other--))
          fi
          ((library--))
          mk1a=$(($lands + $dlands))
          mk1b=$(($mk1a + $shock))
          mk1c=$(($mk1b + $sol))
          mk1d=$(($mk1c + $spirit))
          mk1e=$(($mk1d + $ritual + $hymn))
          mk2=$(($mk1e + $RCC2))
          tab0=$(($mk2 + $GCC0))
          tab1a=$(($tab0 + $first))
          tab1b=$(($tab1a + $motivator + $mass))
          tab1x=$(($tab1b + $oCC1))
          tab2a=$(($tab1x + $G2))
          tab2b=$(($tab2a + $GCC2))
          tab2x=$(($tab2b + $oCC2))
          tab3a=$(($tab2x + $GCC3))
          tab3b=$(($tab3a + $GhCC3 + $G3))
          tab3x=$(($tab3b + $oCC3))
          tab4a=$(($tab3x + $GCC4 + $G4))
          tab4x=$(($tab4a + $oCC4))
          tab5a=$(($tab4x + $G5 + $GCC5))
          tab5x=$(($tab5a + $oCC5))
          tabx=$(($tab5x + $haste))
          other=$(($library - $tabx))
          hmana=$(($hlands + $hdlands + $hshock + $hftech + $hsol + $hRCC2))
          # echo "random num $randomN, library $library, hmana $hmana"
        done
        
        if  (( muligan < 2 )); then
          # if it's a good hand keep, else muligan
          if (( $hmana > 2 && $hmana < 5 && (($hlands + $hshock)) > 1 )); then
            ((hand++))
          else # (( $hmana < 3 )) || (( $hmana > 4 )); then
            ((muligan++))
            ((reset++))
            # echo "muligan"
          fi
        elif  (( muligan == 2 )); then
          # if it's a good hand keep, else muligan
          if (( $hmana > 2 && $hmana < 5 && (($hlands + $hshock)) > 1 )); then
            ((hand++))
            x=1
          else # (( $hmana < 2 )) || (( $hmana > 4 )); then
            ((muligan++))
            ((reset++))
            # echo "muligan"
          fi
        else # alwayskeep the hand
          ((hand++))
          x=2
        fi
        
        # Discarding/sry for muligan
        while (( $x > 0 )); do
        ((x--))
          if (( $hmana > 0 && $hmana < 5 && $hlands > 0 && $x == 1 )); then
            ((hlands--))
            scry=1
          elif (( $hmana > 0 && $hmana < 5 && $hshock > 0 && $x == 1 )); then
            ((hshock--))
            scry=2
          elif (( $hmana > 4 )) && (( $hshock > 0 || $hlands > 0 )); then
            if (( $hRCC2 > 0 )); then
              ((hRCC2--))
              ((RCC2++))
            elif (( $hsol == 1 )); then
              ((hsol--))
              ((sol++))
            elif (( $hhymn == 1 )); then
              ((hhymn--))
              ((hymn++))
            elif (( $hritual == 1 )); then
              ((hritual--))
              ((ritual++))
            elif (( $hspirit == 1 )); then
              ((hspirit--))
              ((spirit++))
            elif (( $hshock > 0 )); then
              ((hshock--))
              ((shock++))
            elif (( $hdlands > 0 )); then
              ((hdlands--))
              ((dlands++))
            elif (( $hlands > 2 )); then
              ((hlands--))
              ((lands++))
            else
              echo "error"
            fi
          elif (( $hhaste > 1 )); then
            ((hhaste--))
            ((haste++))
          elif (( $(($hoCC5 + $hGCC5 + $hG5)) > 1 )); then
            if (( $hoCC5 > 0 )); then
              ((hoCC5--))
              ((oCC5++))
            elif (( $hGCC5 > 0 )); then
              ((hGCC5--))
              ((GCC5++))
            else
              ((hG5--))
              ((G5++))
            fi
          elif (( $(($hoCC4 + $hGCC4 + $hG4)) > 1 )); then
            if (( $hoCC4 > 0 )); then
              ((hoCC4--))
              ((oCC4++))
            elif (( $hGCC4 > 0 )); then
              ((hGCC4--))
              ((GCC4++))
            else
              ((hG4--))
              ((G4++))
            fi
          elif (( $(($hoCC3 + $hGCC3 + $hGhCC3 + $hG3)) > 1 )); then
            if (( $hoCC3 > 0 )); then
              ((hoCC3--))
              ((oCC3++))
            elif (( $hGCC3 > 0 )); then
              ((hGCC3--))
              ((GCC3++))
            elif (( $hG3 > 0 )); then
              ((hG3--))
              ((G3++))
            else
              ((hGhCC3--))
              ((GhCC3++))
            fi
          elif (( $(($hoCC2 + $hGCC2 + $hG2)) > 1 )); then
            if (( $hoCC2 > 0 )); then
              ((hoCC2--))
              ((oCC2++))
            elif (( $hGCC2 > 0 )); then
              ((hGCC2--))
              ((GCC2++))
            else
              ((hG2--))
              ((G2++))
            fi
          elif (( $(($hoCC1 + $hfirst + $hmotivator)) > 1 )); then
            if (( $hoCC1 > 0 )); then
              ((hoCC1--))
              ((oCC1++))
            elif (( $hfirst > 0 )); then
              ((hfirst--))
              ((first++))
            elif (( $hmotivator > 0 )); then
              ((hmotivator--))
              ((motivator++))
            else # (( $hmass > 0 )); then
              ((hmass--))
              ((mass++))
            fi
          elif (( $hother > 0 )); then
            ((hother--))
            ((other++))
          else
            if (( $hoCC5 > 0 )); then
              ((hoCC5--))
              ((oCC5++))
            elif (( $hoCC4 > 0 )); then
              ((hoCC4--))
              ((oCC4++))
            elif (( $hoCC3 > 0 )); then
              ((hoCC3--))
              ((oCC3++))
            elif (( $hoCC2 > 0 )); then
              ((hoCC2--))
              ((oCC2++))
            elif (( $hoCC1 > 0 )); then
              ((hoCC1--))
              ((oCC1++))
            elif (( $hGCC4 > 0 )); then
              ((hGCC4--))
              ((GCC4++))
            elif (( $hGCC3 > 0 )); then
              ((hGCC3--))
              ((GCC3++))
            elif (( $hGCC2 > 0 )); then
              ((hGCC2--))
              ((GCC2++))
            elif (( $hG5 > 0 )); then
              ((hG5--))
              ((G5++))
            elif (( $hhymn > 0 )); then
              ((hhymn--))
              ((hymn++))
            elif (( $hritual > 0 )); then
              ((hritual--))
              ((ritual++))
            elif (( $hspirit > 0 )); then
              ((hspirit--))
              ((spirit++))
            elif (( $hG4 > 0 )); then
              ((hG4--))
              ((G4++))
            elif (( $hG3 > 0 )); then
              ((hG3--))
              ((G3++))
            elif (( $hG2 > 0 )); then
              ((hG2--))
              ((G2++))
            elif (( $hfirst > 0 )); then
              ((hfirst--))
              ((first++))
            elif (( $hGCC0 > 0 )); then
              ((hGCC0--))
              ((GCC0++))
            elif (( $hmotivator > 0 )); then
              ((hmotivator--))
              ((motivator++))
            elif (( $hGhCC3 > 0 )); then
              ((hGhCC3--))
              ((GhCC3++))
            elif (( $hmass > 0 )); then
              ((hmass--))
              ((mass++))
            elif (( $hhaste > 0 )); then
              ((hhaste--))
              ((haste++))
            else
            echo "error discarding $hmana $hhymn $hritual"
            fi
          fi
          ((library++))
          mk1a=$(($lands + $dlands))
          mk1b=$(($mk1a + $shock))
          mk1c=$(($mk1b + $sol))
          mk1d=$(($mk1c + $spirit))
          mk1e=$(($mk1d + $ritual + $hymn))
          mk2=$(($mk1e + $RCC2))
          tab0=$(($mk2 + $GCC0))
          tab1a=$(($tab0 + $first))
          tab1b=$(($tab1a + $motivator + $mass))
          tab1x=$(($tab1b + $oCC1))
          tab2a=$(($tab1x + $G2))
          tab2b=$(($tab2a + $GCC2))
          tab2x=$(($tab2b + $oCC2))
          tab3a=$(($tab2x + $GCC3))
          tab3b=$(($tab3a + $GhCC3 + $G3))
          tab3x=$(($tab3b + $oCC3))
          tab4a=$(($tab3x + $GCC4 + $G4))
          tab4x=$(($tab4a + $oCC4))
          tabx=$(($tab4x + $haste))
          other=$(($library - $tabx))
          hmana=$(($hlands + $hdlands + $hshock + $hftech + $hsol + $hRCC2))
        done
      done
      
    else # we are playing our turn
    
      mana=$(($mana_s))
      c_sick=0
      land_drop=0
      
      # draw a card, if we didn't scry
      if (( scy == 0 )); then
        randomN=$((1 + $RANDOM % $library))
        
        if (( $randomN <= $lands )); then
          ((hlands++))
          ((lands--))
        elif (( $randomN > $lands && $randomN <= $mk1a )); then
          ((hdlands++))
          ((dlands--))
        elif (( $randomN > $mk1a && $randomN <= $mk1b )); then
          ((hshock++))
          ((shock--))
        elif (( $randomN > $mk1b && $randomN <= $mk1c  )); then
          ((hsol++))
          ((sol--))
        elif (( $randomN > $mk1c && $randomN == $mk1d && $spirit == 1 )); then
          ((hspirit++))
          ((spirit--))
        elif (( $randomN > $mk1d && $randomN == $mk1e && $ritual == 1 )); then
          ((hritual++))
          ((ritual--))
        elif (( $randomN > $mk1d && $randomN <= $mk1e )); then
          ((hhymn++))
          ((hymn--))
        elif (( $randomN > $mk1e && $randomN <= $mk2 )); then
          ((hRCC2++))
          ((RCC2--))
        elif (( $randomN > $mk2 && $randomN == $tab0 && $GCC0 == 1 )); then
          ((hGCC0++))
          ((GCC0--))
        elif (( $randomN > $tab0 && $randomN <= $tab1a )); then
          ((hfirst++))
          ((first--))
        elif (( $randomN > $tab1a && $randomN == $tab1b && $motivator == 1 )); then
          ((hmotivator++))
          ((motivator--))
        elif (( $randomN > $tab1a && $randomN <= $tab1b )); then
          ((hmass++))
          ((mass--))
        elif (( $randomN > $tab1b && $randomN <= $tab1x )); then
          ((hoCC1++))
          ((oCC1--))
        elif (( $randomN > $tab1x && $randomN <= $tab2a )); then
          ((hG2++))
          ((G2--))
        elif (( $randomN > $tab2a && $randomN <= $tab2b )); then
          ((hGCC2++))
          ((GCC2--))
        elif (( $randomN > $tab2b && $randomN <= $tab2x )); then
          ((hoCC2++))
          ((oCC2--))
        elif (( $randomN > $tab2x && $randomN <= $tab3a )); then
          ((hGCC3++))
          ((GCC3--))
        elif (( $randomN > $tab3a && $randomN == $tab3b && $G3 == 1 )); then
          ((hG3++))
          ((G3--))
        elif (( $randomN > $tab3a && $randomN <= $tab3b )); then
          ((hGhCC3++))
          ((GhCC3--))
        elif (( $randomN > $tab3b && $randomN <= $tab3x )); then
          ((hoCC3++))
          ((oCC3--))
        elif (( $randomN > $tab3x && $randomN == $tab4a && $G4 == 1 )); then
          ((hG4++))
          ((G4--))
        elif (( $randomN > $tab3x && $randomN <= $tab4a )); then
          ((hGCC4++))
          ((GCC4--))
        elif (( $randomN > $tab4a && $randomN <= $tab4x )); then
          ((hoCC4++))
          ((oCC4--))
        elif (( $randomN > $tab4x && $randomN == $tab5a && $GCC5 == 1 )); then
          ((hGCC5++))
          ((GCC5--))
        elif (( $randomN > $tab4x && $randomN <= $tab5a )); then
          ((hG5++))
          ((G5--))
        elif (( $randomN > $tab5a && $randomN <= $tab5x )); then
          ((hoCC5++))
          ((oCC5--))
        elif (( $randomN > $tab4x && $randomN <= $tabx )); then
          ((hhaste++))
          ((haste--))
        else # (( $randomN > $mk1b && $randomN <= $tab1 )); then
          ((hother++))
          ((other--))
        fi
        ((library--))
        mk1a=$(($lands + $dlands))
        mk1b=$(($mk1a + $shock))
        mk1c=$(($mk1b + $sol))
        mk1d=$(($mk1c + $spirit))
        mk1e=$(($mk1d + $ritual + $hymn))
        mk2=$(($mk1e + $RCC2))
        tab0=$(($mk2 + $GCC0))
        tab1a=$(($tab0 + $first))
        tab1b=$(($tab1a + $motivator + $mass))
        tab1x=$(($tab1b + $oCC1))
        tab2a=$(($tab1x + $G2))
        tab2b=$(($tab2a + $GCC2))
        tab2x=$(($tab2b + $oCC2))
        tab3a=$(($tab2x + $GCC3))
        tab3b=$(($tab3a + $GhCC3 + $G3))
        tab3x=$(($tab3b + $oCC3))
        tab4a=$(($tab3x + $GCC4 + $G4))
        tab4x=$(($tab4a + $oCC4))
        tab5a=$(($tab4x + $G5 + $GCC5))
        tab5x=$(($tab5a + $oCC5))
        tabx=$(($tab5x + $haste))
        other=$(($library - $tabx))
        # echo "random num $randomN, library $library, game draw"
      
      elif (( scry == 1 )); then
        ((hlands++))
        ((library--))
        scry=0
      else # (( scry == 2 )); then
        ((hshock++))
        ((library--))
        scry=0
      fi
      
      # play land
      if (( $hlands > 0 && $turn == 1 )); then
        ((hlands--))
        ((land_drop++))
        ((mana++))
        ((mana_s++))
      elif (( $hdlands > 0 )) && (( $hlands == 0 || $turn > 1 )); then
        ((hdlands--))
        ((land_drop++))
        mana=$(($mana + 2))
        mana_s=$(($mana_s + 2))
      elif (( $hshock > 0 )) && (( $hlands == 0 || $commander == 1 || $mana_s > 3 )); then
        ((lands--))
        ((hshock--))
        ((land_drop++))
        ((mana++))
        ((mana_s++))
        ((library--))
        mk1a=$(($lands + $dlands))
        mk1b=$(($mk1a + $shock))
        mk1c=$(($mk1b + $sol))
        mk1d=$(($mk1c + $spirit))
        mk1e=$(($mk1d + $ritual + $hymn))
        mk2=$(($mk1e + $RCC2))
        tab0=$(($mk2 + $GCC0))
        tab1a=$(($tab0 + $first))
        tab1b=$(($tab1a + $motivator + $mass))
        tab1x=$(($tab1b + $oCC1))
        tab2a=$(($tab1x + $G2))
        tab2b=$(($tab2a + $GCC2))
        tab2x=$(($tab2b + $oCC2))
        tab3a=$(($tab2x + $GCC3))
        tab3b=$(($tab3a + $GhCC3 + $G3))
        tab3x=$(($tab3b + $oCC3))
        tab4a=$(($tab3x + $GCC4 + $G4))
        tab4x=$(($tab4a + $oCC4))
        tab5a=$(($tab4x + $G5 + $GCC5))
        tab5x=$(($tab5a + $oCC5))
        tabx=$(($tab5x + $haste))
        other=$(($library - $tabx))
      elif (( $hlands > 0 )); then
        ((hlands--))
        ((land_drop++))
        ((mana++))
        ((mana_s++))
      fi
      
      #### refine next step ###
      if (( $turn == 1 && $mana > 0 )); then
        if (( $hGCC0 > 0 )); then
          ((hGCC0--))
          ((goblin++))
          ((first_blood++))
          x=1
        fi
        if (( $hfirst > 0 )); then
          ((mana--))
          ((hfirst--))
          ((goblin++))
          if (( $x == 0 )); then
            ((first_blood++))
          fi
        elif (( $hsol && $mana > 0 )); then
          ((mana++))
          ((hsol--))
          ((mana_s++))
          ((mana_s++))
          if (( $hRCC2 > 0 && $mana > 1 )); then
            ((mana--))
            ((hRCC2--))
            ((mana_s++))
            if (( $hfirst > 0 && $mana > 0 )); then
              ((mana--))
              ((hfirst--))
              ((goblin++))
            fi
          fi
        elif (( $hmass > 0 )); then
          ((mana--))
          ((hmass--))
          perma_haste=1
        elif (( $hmotivator > 0 )); then
          ((mana--))
          ((hmotivator--))
          ((haste_s++))
          ((goblin++))
        elif (( $hoCC1 > 0 )); then
          ((mana--))
          ((hoCC1--))
        fi
      fi
      
      if (( $turn == 2 )); then
        if (( $hGCC0 > 0 )); then
          ((hGCC0--))
          ((goblin++))
        fi
        
        if (( $mana > 0 )); then
          if (( $hsol == 1 )); then
            ((mana++))
            ((hsol--))
            ((mana_s++))
            ((mana_s++))
          fi
          if (( $hRCC2 > 0 && $mana > 1 )); then
            ((mana--))
            ((hRCC2--))
            ((mana_s++))
          fi
          
          while (( $mana > 1 )); do
            if (( $hG2 > 0 && $mana > 1 )); then
              mana=$(($mana - 2))
              ((hG2--))
              goblin=$(($goblin + 2))
            elif (( $hGCC2 > 0 && $mana > 1 )); then
              mana=$(($mana - 2))
              ((hGCC2--))
              ((goblin++))
            elif (( $hoCC2 > 0 && $mana > 1 )); then
              mana=$(($mana - 2))
              ((hoCC2--))
            else
              ((mana--))
              ((y++))
            fi
          done
          mana=$(($mana + $y))
          y=0
          while (( $mana > 0 )); do
            if (( $hmass > 0  && $mana > 0 )); then
              ((mana--))
              ((hmass--))
              perma_haste=1
            elif (( $hmotivator > 0 && $mana > 0 )); then
              ((mana--))
              ((hmotivator--))
              ((haste_s++))
              ((goblin++))
            elif (( $hfirst > 0 && $mana > 0 )); then
              ((mana--))
              ((hfirst--))
              ((goblin++))
            elif (( $oCC1 > 0 && $mana > 0 )); then
              ((mana--))
              ((hoCC1--))
            else
              ((mana--))
              ((y++))
            fi
          done
          mana=$(($mana + $y))
          y=0
        fi
      fi
      
      ################################################################
      
      if (( $turn >= 3 )); then
        
        if (( $hGCC0 > 0 )); then
          ((hGCC0--))
          ((goblin++))
        fi
        
        if (( $commander == 0 )) && \
        (( $mana >= 4 || $hritual == 1 || $hhymn == 1 || $hspirit == 1 )); then
          if (( $mana == 3 && $hspirit == 1 )); then
            commander=1
            mana=$(($mana - 3))
            ((hspirit--))
            ((goblin++))
          elif (( $mana >= 4 )); then
            commander=1
            mana=$(($mana - 4))
            ((goblin++))
          elif (( $hritual == 1 && $(($mana + $goblin -1)) >= 4 && $mana >= 1 )); then
            ((hritual--))
            mana=$(($mana + $goblin))
            commander=1
            mana=$(($mana - 5))
            ((goblin++))
          elif (( $hhymn == 1 && $(($mana + $goblin -2)) >= 4 && $mana >= 2 )); then
            ((hhymn--))
            mana=$(($mana + $goblin))
            commander=1
            mana=$(($mana - 6))
            ((goblin++))
          fi
          if (( $haste_s == 0 || $perma_haste == 0 )); then
            c_sick=1
          fi
        fi
        
        ### mana rocks ###
        if (( $hsol == 1 && $mana > 0 )); then
          ((mana++))
          ((hsol--))
          mana_s=$(($mana_s + 2))
        fi
        if (( $hRCC2 > 1 && $mana > 1 )); then
          ((mana--))
          ((hRCC2--))
          ((mana_s++))
        fi
        
        ### extra mana ###
        if (( $hspirit == 1 && $commander == 1 )); then
          ((hspirit--))
          ((mana++))
        fi
        if (( $hritual == 1 && $commander == 1 && $mana >= 1 )) && \
        (($hfirst + $hmotivator + $hoCC1 + $hmass + (($hGCC2 + $hG2 + $hoCC2))*2 + \
        (($hGCC3 + $hGhCC3 + $hG3 + $hoCC3))*3 + \
        (($hGCC4 + $hG4 + $hoCC4))*4 < $(($mana + $goblin)) )); then
          ((mana--))
          ((hritual--))
          mana=$(($mana + $goblin))
        elif (( $hhymn == 1 && $commander == 1 && $mana >= 2 )) && \
        (($hfirst + $hmotivator + $hoCC1 + $hmass + (($hGCC2 + $hG2 + $hoCC2))*2 + \
        (($hGCC3 + $hGhCC3 + $hG3 + $hoCC3))*3 + \
        (($hGCC4 + $hG4 + $hoCC4))*4 < $(($mana + $goblin + 1)) )); then
          mana=$(($mana - 2))
          ((hhymn--))
          mana=$(($mana + $goblin))
        fi
        
        ### playing cards ###
        if (( $mana > 0 )); then
          
          while (( $mana > 0 )); do
            if (( $hG5 > 0 && $mana > 4 )); then
              mana=$(($mana - 5))
              ((hG5--))
              goblin=$(($goblin + 4))
            elif (( $hG4 > 0 && $mana > 3 )); then
              mana=$(($mana - 4))
              ((hG4--))
              goblin=$(($goblin + 3))
            elif (( $hGhCC3 > 0 && $mana > 2 && $perma_haste == 0 )); then
              mana=$(($mana - 3))
              ((hGhCC3--))
              ((goblin++))
              perma_haste=1
            elif (( $hG3 > 0 && $mana > 2 )); then
              mana=$(($mana - 3))
              ((hG3--))
              goblin=$(($goblin + 3))
            elif (( $hG2 > 0 && $mana > 1 )); then
              mana=$(($mana - 2))
              ((hG2--))
              goblin=$(($goblin + 2))
            elif (( $hmass > 0  && $mana > 0 )); then
              ((mana--))
              ((hmass--))
              perma_haste=1
            elif (( $hmotivator > 0 && $mana > 0 )); then
              ((mana--))
              ((hmotivator--))
              ((haste_s++))
              ((goblin++))
            elif (( $hfirst > 0 && $mana > 0 )); then
              ((mana--))
              ((hfirst--))
              ((goblin++))
            else # store mana
              ((mana--))
              ((y++))
            fi
          done
          mana=$(($mana + $y))
          y=0
          
          while (( $mana > 0 )); do
            if (( $hGCC5 > 0 && $mana > 4 )); then
              mana=$(($mana - 5))
              ((hGCC5--))
              ((goblin++))
            elif (( $hGCC4 > 0 && $mana > 3 )); then
              mana=$(($mana - 4))
              ((hGCC4--))
              ((goblin++))
            elif (( $hGCC3 > 0 && $mana > 2 )); then
              mana=$(($mana - 3))
              ((hGCC3--))
              ((goblin++))
            elif (( $hGCC2 > 0 && $mana > 1 )); then
              mana=$(($mana - 2))
              ((hGCC2--))
              ((goblin++))
            else
              ((mana--))
              ((y++))
            fi
          done
          mana=$(($mana + $y))
          y=0
          
          while (( $mana > 0 )); do
            if (( $hoCC4 > 0 && $mana > 3 )); then
              mana=$(($mana - 4))
              ((hoCC4--))
            elif (( $hoCC3 > 0 && $mana > 2 )); then
              mana=$(($mana - 3))
              ((hoCC3--))
            elif (( $hoCC2 > 0 && $mana > 1 )); then
              mana=$(($mana - 2))
              ((hoCC2--))
            elif (( $hoCC1 > 0 && $mana > 0 )); then
              ((mana--))
              ((hoCC2--))
            else
              ((mana--))
              ((y++))
            fi
          done
          mana=$(($mana + $y))
          y=0
          
        fi
      fi
      
      ##################################################
      
      if (( $commander == 1 && $c_sick == 0 )); then
        goblin=$(($goblin*2))
      fi
      
      mana_waste=$(($mana_waste + $mana))
      
    fi
    
done

if (( $turn <= 4 ));then
  ((turn4_deploy++))
elif (( $turn == 5 )); then
  ((turn5_deploy++))
elif (( $turn == 6 )); then
  ((turn6_deploy++))
elif (( $turn == 7 )); then
  ((turn7_deploy++))
else # (( $turn >= 8 )); then
  ((turn8p_deploy++))
fi

temp=$(($muliganC1 + $muliganC2 + $muliganC3))

if (( $muligan > 0 )); then
  if (( $muligan == 1 ));then
    ((muliganC1++))
  elif (( $muligan == 2 ));then
    ((muliganC2++))
  else # (( $muligan == 3 ));then
    ((muliganC3++))
  fi
fi

((sim++))

done

echo "% first blood"
echo "scale=3 ; $first_blood / $sim_goal" | bc
echo ""

echo "mana waste"
echo "scale=3 ; $mana_waste / $sim_goal" | bc
echo ""

echo "% games with muligan"
echo "scale=3 ; $temp / $sim_goal" | bc
echo "percent breakdown"
echo "scale=3 ; $muliganC1 / $sim_goal" | bc
echo "scale=3 ; $muliganC2 / $sim_goal" | bc
echo "scale=3 ; $muliganC3 / $sim_goal" | bc

echo ""
echo "turn four $turn4_deploy"
echo "turn five $turn5_deploy"
echo "turn six $turn6_deploy"
echo "turn seven $turn7_deploy"
echo "turn eight+ $turn8p_deploy"
echo ""

end=`date +%s`
runtime=$((end-start))
echo "runtime $runtime"