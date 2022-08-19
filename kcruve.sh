#!/bin/bash

# building a mtg mana probability distribution

sim=0
sim_goal=1000

turn4_deploy=0
turn5_deploy=0
turn6_deploy=0
turn7_deploy=0
turn8p_deploy=0

muliganC1=0
muliganC2=0
muliganC3=0

mana_waste=0

############################################################

while (( $sim < $sim_goal))
do

reset=2

turn=-1
muligan=0
hand=0 #0 for unaccepted, 1 for accepter

mana_s=0

goblin=0
land_drop=0

# 1:land, 2:other
scry=0

mana=0
commander=0
c_sick=0
x=0
y=0

while (( $goblin < 14 )); do
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
          fetch=0
          shock=3
          sol=1
          RCC2=4 # 4 colored & 4 non-colored exist that don't come in tapped
          
          first=13
          two=19
          three=15
          four=5
          five=3
          
          mk1a=$(($lands + $dlands))
          mk1b=$(($mk1a + $shock))
          mk1c=$(($mk1b + $fetch + $sol))
          mk2=$(($mk1c + $RCC2))
          
          tab1=$(($mk2 + $first))
          tab2=$(($tab1 + $two))
          tab3=$(($tab2 + $three))
          tab4=$(($tab3 + $four))
          tab5=$(($tab4 + $five))
          other=$(($library - $tab5))
          
          hlands=0
          hdlands=0
          hfetch=0
          hshock=0
          hsol=0
          hRCC2=0
          hmana=0
          
          hfirst=0
          htwo=0
          hthree=0
          hfour=0
          hfive=0
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
          elif (( $randomN > $mk1b && $randomN == $mk1c && $sol == 1 )); then
            ((hsol++))
            ((sol--))
          elif (( $randomN > $mk1b && $randomN <= $mk1c )); then
            ((hfetch++))
            ((fetch--))
          elif (( $randomN > $mk1c && $randomN <= $mk2 )); then
            ((hRCC2++))
            ((RCC2--))
          elif (( $randomN > $mk2 && $randomN <= $tab1 )); then
            ((hfirst++))
            ((first--))
          elif (( $randomN > $tab1 && $randomN <= $tab2 )); then
            ((htwo++))
            ((two--))
          elif (( $randomN > $tab2 && $randomN <= $tab3 )); then
            ((hthree++))
            ((three--))
          elif (( $randomN > $tab3 && $randomN <= $tab4 )); then
            ((hfour++))
            ((four--))
          elif (( $randomN > $tab4 && $randomN <= $tab5 )); then
            ((hfive++))
            ((five--))
          else # (( $randomN > $mk1b && $randomN <= $tab1 )); then
            ((hother++))
            ((other--))
            # echo "draw other"
          fi
          ((library--))
          mk1a=$(($lands + $dlands))
          mk1b=$(($mk1a + $shock))
          mk1c=$(($mk1b + $fetch + $sol))
          mk2=$(($mk1c + $RCC2))
          tab1=$(($mk2 + $first))
          tab2=$(($tab1 + $two))
          tab3=$(($tab2 + $three))
          tab4=$(($tab3 + $four))
          tab5=$(($tab4 + $five))
          other=$(($library - $tab5))
          hmana=$(($hlands + $hdlands + $hshock + $hftech + $hsol + $hRCC2))
        done
        
        if  (( muligan < 2 )); then
          # if it's a good hand keep, else muligan
          if (( $hmana > 2 && $hmana < 5 && (($hlands + $hshock)) > 1 )); then
            ((hand++))
          else # (( $hmana < 3 )) || (( $hmana > 4 )); then
            ((muligan++))
            ((reset++))
          fi
        elif  (( muligan == 2 )); then
          # if it's a good hand keep, else muligan
          if (( $hmana > 2 && $hmana < 5 && (($hlands + $hshock)) > 1 )); then
            ((hand++))
            x=1
          else # (( $hmana < 2 )) || (( $hmana > 4 )); then
            ((muligan++))
            ((reset++))
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
          elif (( $hmana > 4 && (($hlands + $hshock)) > 1 )); then
            if (( $hfetch > 0 )); then
              ((hfetch--))
              ((fetch++))
            elif (( $hshock > 0 )); then
              ((hshock--))
              ((shock++))
            elif (( $hRCC2 > 0 )); then
              ((hRCC2--))
              ((RCC2++))
            elif (( $hsol == 1 )); then
              ((hsol--))
              ((sol++))
            elif (( $hdlands > 0 )); then
              ((hdlands--))
              ((dlands++))
            elif (( $hlands > 2 )); then
              ((hlands--))
              ((lands++))
            else
              echo "error"
            fi
          elif (( $hfive > 1 )); then
             ((hfive++))
             ((five--))
          elif (( $hfour > 0 )); then
             ((hfour++))
             ((four--))
          elif (( $hthree > 1 )); then
            ((hthree--))
            ((three++))
          elif (( $htwo > 1 )); then
             ((htwo++))
             ((two--))
          elif (( $hfirst > 1 )); then
            ((hfirst++))
            ((first--))
          else
            if (( $hfive > 0 )); then
               ((hfive++))
               ((five--))
            elif (( $hthree > 0 )); then
              ((hthree--))
              ((three++))
            elif (( $htwo > 0 )); then
               ((htwo++))
               ((two--))
            elif (( $hfirst > 0 )); then
              ((hfirst++))
              ((first--))
            elif (( $hother > 0 )); then
              ((hother--))
              ((other++))
            else
            echo "error discarding"
            fi
          fi
          ((library--))
          mk1a=$(($lands + $dlands))
          mk1b=$(($mk1a + $shock))
          mk1c=$(($mk1b + $fetch + $sol))
          mk2=$(($mk1c + $RCC2))
          tab1=$(($mk2 + $first))
          tab2=$(($tab1 + $two))
          tab3=$(($tab2 + $three))
          tab4=$(($tab3 + $four))
          tab5=$(($tab4 + $five))
          other=$(($library - $tab5))
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
        elif (( $randomN > $mk1b && $randomN == $mk1c && $sol == 1 )); then
          ((hsol++))
          ((sol--))
        elif (( $randomN > $mk1b && $randomN <= $mk1c )); then
          ((hfetch++))
          ((fetch--))
        elif (( $randomN > $mk1c && $randomN <= $mk2 )); then
          ((hRCC2++))
          ((RCC2--))
        elif (( $randomN > $mk2 && $randomN <= $tab1 )); then
          ((hfirst++))
          ((first--))
        elif (( $randomN > $tab1 && $randomN <= $tab2 )); then
          ((htwo++))
          ((two--))
        elif (( $randomN > $tab2 && $randomN <= $tab3 )); then
          ((hthree++))
          ((three--))
        elif (( $randomN > $tab3 && $randomN <= $tab4 )); then
          ((hfour++))
          ((four--))
        elif (( $randomN > $tab4 && $randomN <= $tab5 )); then
          ((hfive++))
          ((five--))
        else # (( $randomN > $mk1b && $randomN <= $tab1 )); then
          ((hother++))
          ((other--))
        fi
        ((library--))
        mk1a=$(($lands + $dlands))
        mk1b=$(($mk1a + $shock))
        mk1c=$(($mk1b + $fetch + $sol))
        mk2=$(($mk1c + $RCC2))
        tab1=$(($mk2 + $first))
        tab2=$(($tab1 + $two))
        tab3=$(($tab2 + $three))
        tab4=$(($tab3 + $four))
        tab5=$(($tab4 + $five))
        other=$(($library - $tab5))
      
      else # (( scry == 1 )); then
        ((hlands++))
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
      elif (( $hshock > 0 )) && (( $hlands == 0 || $turn > 3 )); then
        ((lands--))
        ((hshock--))
        ((land_drop++))
        ((mana++))
        ((mana_s++))
        ((library--))
        mk1a=$(($lands + $dlands))
        mk1b=$(($mk1a + $shock))
        mk1c=$(($mk1b + $fetch + $sol))
        mk2=$(($mk1c + $RCC2))
        tab1=$(($mk2 + $first))
        tab2=$(($tab1 + $two))
        tab3=$(($tab2 + $three))
        tab4=$(($tab3 + $four))
        other=$(($library - $tab4))
      elif (( $hfetch > 0 && $hlands == 0 )) || [[ $hfetch -gt 0 && $mana_s -ne 3 && $hlands -gt 0 ]]; then
        if (( $mana_s == 3 && $hlands > 0 )); then
          echo "error playing fetch"
        fi
        ((lands--))
        ((hfetch--))
        ((land_drop++))
        ((mana_s++))
        ((library--))
        mk1a=$(($lands + $dlands))
        mk1b=$(($mk1a + $shock))
        mk1c=$(($mk1b + $fetch + $sol))
        mk2=$(($mk1c + $RCC2))
        tab1=$(($mk2 + $first))
        tab2=$(($tab1 + $two))
        tab3=$(($tab2 + $three))
        tab4=$(($tab3 + $four))
        tab5=$(($tab4 + $five))
        other=$(($library - $tab5))
      elif (( $hlands > 0 )); then
        ((hlands--))
        ((land_drop++))
        ((mana++))
        ((mana_s++))
      fi
      
      #### refine next step ###
      if (( $turn == 1 && $mana > 0 )); then
        if (( $hfirst > 0 )); then
          ((mana--))
          ((hfirst--))
          ((goblin++))
        fi
        if (( $hsol && $mana > 0 )); then
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
        fi
      fi
      
      if (( $turn == 2 && $mana > 0 )); then
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
          if (( $hfirst > 0 && $mana > 0 )); then
            ((mana--))
            ((hfirst--))
            ((goblin++))
          fi
        fi
        if (( $mana > 0 )); then
          while (( $mana > 1 )); do
            if (( $htwo > 0 && $mana > 1 )); then
              mana=$(($mana - 2))
              ((htwo--))
              ((goblin++))
            else
              ((mana--))
              ((y++))
            fi
          done
          mana=$(($mana + $y))
          y=0
          while (( $mana > 0 )); do
            if (( $hfirst > 0 && $mana > 0 )); then
              ((mana--))
              ((hfirst--))
              ((goblin++))
            else
              ((mana--))
              ((y++))
            fi
          done
          mana=$(($mana + $y))
          y=0
        fi
      fi
      
      if (( $turn >= 3 )); then
        if (( $mana >= 4 && $commander == 0 )); then
          commander=1
          mana=$(($mana - 4))
          ((goblin++))
          c_sick=1
        fi
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
        while (( $mana > 0 )); do
          if (( $hfive > 0 && $mana > 4 )); then
            mana=$(($mana - 4))
            ((hfive--))
            ((goblin++))
          elif (( $hfour > 0 && $mana > 3 )); then
            mana=$(($mana - 4))
            ((hfour--))
            ((goblin++))
          elif (( $hthree > 0 && $mana > 2 )); then
            mana=$(($mana - 3))
            ((hthree--))
            ((goblin++))
          elif (( $htwo > 0 && $mana > 1 )); then
            mana=$(($mana - 2))
            ((htwo--))
            ((goblin++))
          elif (( $hfirst > 0 && $mana > 0 )); then
            ((mana--))
            ((hfirst--))
            ((goblin++))
          else
            ((mana--))
            ((y++))
          fi
        done
        mana=$(($mana + $y))
        y=0
      fi
      
      # echo "ending turn $turn with $mana_s mana sources on board"
      
      if (( $commander == 1 && $c_sick == 0 )); then
        goblin=$(($goblin*2))
      fi
      
      mana_waste=$(( $mana_waste + $mana))
      
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
