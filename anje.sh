#!/bin/bash

# building a mtg mana probability distribution

start=`date +%s`

sim=0
sim_goal=10000

lost=0

turn2_deploy=0
turn3_deploy=0
turn4_deploy=0
turn5_deploy=0
turn6p_deploy=0

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

land_drop=0

mana=0
commander=0
x=0
y=0

while (( $commander < 1 )); do
  ((turn++))

    # we are in the draw step
    if (( $turn == 0 )); then
    
      while (( $hand < 1 )); do
        
        # reset when starting a game and
        if (( $reset > 0 ));then
          
          reset=0
          library=99
          count=0
          
          # building an array for all cards in library
          
          # section 1 of array has mana sources, element 0-8
          # lands, shocks, fetch, sol ring, CC2 mana rocks, card for 1 mana
          deck=(20 1 2 1 2 0)
          
          # section 2 of array is to determine CC of cards, starting with madness cards
          deck=(${deck[@]} 45 0 0 0 8 6 3)
          
          x=0
          for i in ${deck[@]}; do
            let x+=$i
          done
          
          if (( $x < $library )); then
            # echo "library not in sync"
            other=$((99 - $x))
            deck[12]=$((${deck[12]} + $other))
          elif (( $x > $library)); then
            echo "too many cards"
          fi
          x=0
          
          hlands=0
          hshock=0
          hfetch=0
          hsol=0
          hRCC2=0
          
          hmana=0
          
          hspirit=0
          
          hmad=0
          hCC1=0
          hCC2=0
          hCC3=0
          hCC4=0
          hCC5=0
          hCC6=0
          
        fi
        
        while (( count < 7 )); do
          ((count++))
          
          # Generate the random number, upper bound is library size to draw a card
          randomN=$((1 + $RANDOM % $library))
          # this will how we find the card we drew
          position=-1
          card=0
          
          while (( $card < $randomN )); do
            ((position++))
            card=$(( $card + ${deck[$position]} ))
            # if (( $position > 26 )); then
            #   echo "eror beyond array"
            # fi
          done
          ((deck[$position]--))
          ((library--))
          
          if (( $position == 0 )); then
            ((hlands++))
          elif (( $position == 1 )); then
            ((hshock++))
          elif (( $position == 2 )); then
            ((hfetch++))
          elif (( $position == 3 )); then
            ((hsol++))
          elif (( $position == 4 )); then
            ((hRCC2++))
          elif (( $position == 5 )); then
            ((hspirit++))
          elif (( $position == 6 )); then
            ((hmad++))
          elif (( $position == 7 )); then
            ((hCC1++))
          elif (( $position == 8 )); then
            ((hCC2++))
          elif (( $position == 9 )); then
            ((hCC3++))
          elif (( $position == 10 )); then
            ((hCC4++))
          elif (( $position == 11 )); then
            ((hCC5++))
          elif (( $position == 12 )); then
            ((hCC6++))
          else
            echo "error drawing a card"
          fi
          hmana=$(($hlands + $hshock + $hfetch + $hsol + $hRCC2 + $hspirit))
        done
        
        if  (( muligan < 2 )); then
          # if it's a good hand keep, else muligan
          if (( $hmana > 1 && (($hlands + $hshock + $hfetch)) > 0 )); then
            ((hand++))
          else # (( $hmana < 3 )); then
            ((muligan++))
            ((reset++))
          fi
        elif  (( muligan == 2 )); then
          # if it's a good hand keep, else muligan
          if (( $hmana > 1 && (($hlands + $hshock + $hfetch)) > 0 )); then
            ((hand++))
            x=1
          else # (( $hmana < 3 )); then
            ((muligan++))
            ((reset++))
          fi
        elif  (( muligan == 3 )); then
          # if it's a good hand keep, else muligan
          if (( $hmana > 1 && (($hlands + $hshock + $hfetch)) > 0 )); then
            ((hand++))
            x=2
          else # (( $hmana < 3 )); then
            ((muligan++))
            ((reset++))
          fi
        else # you lost already
          commander=1
          turn=100
          ((hand++))
          ((lost++))
        fi
        
        # Discarding/sry for muligan
        while (( $x > 0 )); do
        ((x--))
          if (( $hmana > 3 )); then
            if (( $hlands )) > 0; then
              ((hlands--))
              ((deck[0]++))
            elif (( $hfetch > 0 )); then
              ((hfetch--))
              ((deck[2]++))
            elif (( $hshock > 0 )); then
             ((hshock--))
             ((deck[1]++))
            elif (( $hRCC2 > 0 )); then
              ((hRCC2--))
              ((deck[4]++))
            elif (( $hsol == 1 )); then
              ((hsol--))
              ((deck[3]++))
            elif (( $hspirit > 0 )); then
              ((hspirit--))
              ((deck[5]++))
            else
              echo "error disc. lands"
            fi
          elif (( $hmad > 0 || $hCC1 > 1 || $hCC2 > 1 || \
          $hCC3 > 1 || $hCC4 > 1 || $hCC5 > 1 || $hCC6 > 1)); then
            if (( $hmad > 0 )); then
              ((hmad--))
              ((deck[6]++))
            elif (( $hCC1 > 1 )); then
              ((hCC1--))
              ((deck[7]++))
            elif (( $hCC2 > 1 )); then
              ((hCC2--))
              ((deck[8]++))
            elif (( $hCC3 > 1 )); then
              ((hCC3--))
              ((deck[9]++))
            elif (( $hCC4 > 1 )); then
              ((hCC4--))
              ((deck[10]++))
            elif (( $hCC5 > 1 )); then
              ((hCC5--))
              ((deck[11]++))
            elif (( $hCC6 > 1 )); then
              ((hCC6--))
              ((deck[12]++))
            else
            echo "error discarding double slot"
            fi
          else
            if (( $hCC1 > 0 )); then
              ((hCC1--))
              ((deck[7]++))
            elif (( $hCC2 > 0 )); then
              ((hCC2--))
              ((deck[8]++))
            elif (( $hCC3 > 0 )); then
              ((hCC3--))
              ((deck[9]++))
            elif (( $hCC4 > 0 )); then
              ((hCC4--))
              ((deck[10]++))
            elif (( $hCC5 > 0 )); then
              ((hCC5--))
              ((deck[11]++))
            elif (( $hCC6 > 0 )); then
              ((hCC6--))
              ((deck[12]++))
            else
            echo "error discarding absolute"
            fi
          fi
          ((library++))
          hmana=$(($hlands + $hshock + $hfetch + $hsol + $hRCC2 + $hspirit))
        done
      done
      
    else # we are playing our turn
    
      mana=$(($mana_s))
      land_drop=0
      
      # Generate the random number, upper bound is library size to draw a card
      randomN=$((1 + $RANDOM % $library))
      # this will how we find the card we drew
      position=-1
      card=0
        
      while (( $card < $randomN )); do
        ((position++))
        card=$(( $card + ${deck[$position]} ))
      done
      ((deck[$position]--))
      ((library--))
        
      if (( $position == 0 )); then
        ((hlands++))
      elif (( $position == 1 )); then
        ((hshock++))
      elif (( $position == 2 )); then
        ((hfetch++))
      elif (( $position == 3 )); then
        ((hsol++))
      elif (( $position == 4 )); then
        ((hRCC2++))
      elif (( $position == 5 )); then
        ((hspirit++))
      elif (( $position == 6 )); then
        ((hmad++))
      elif (( $position == 7 )); then
        ((hCC1++))
      elif (( $position == 8 )); then
        ((hCC2++))
      elif (( $position == 9 )); then
        ((hCC3++))
      elif (( $position == 10 )); then
        ((hCC4++))
      elif (( $position == 11 )); then
        ((hCC5++))
      elif (( $position == 12 )); then
        ((hCC6++))
      else
        echo "error drawing a card"
      fi
      hmana=$(($hlands + $hshock + $hfetch + $hsol + $hRCC2 + $hspirit))
      
      # play land
      if (( $hfetch > 0 )); then
        ((hfetch--))
        ((land_drop++))
        ((mana_s++))
        ((deck[0]--))
        ((library--))
      elif (( $hlands > 0 )); then
        ((hlands--))
        ((land_drop++))
        ((mana++))
        ((mana_s++))
      elif (( $hshock > 0 )); then
        ((hshock--))
        ((land_drop++))
        ((mana++))
        ((mana_s++))
        ((deck[0]--))
        ((library--))
      fi
      
      #### refine next step ###
      
      mad=1
      
      # turn 1 #
      if (( $turn == 1 )); then
        if (( $hsol > 0 && $mana > 0 )); then
          ((hsol--))
          ((mana++))
          ((mana_s++))
          ((mana_s++))
        elif (( $hCC1 > 0 && $mana > 0 )); then
          ((hCC1--))
          ((mana--))
        fi
        
      ## turn 2 ##
      
      elif (( $turn < 6 )); then
        
        ## try to play commander ##
        if (( $commander == 0 )) && (( $mana > 2 || $hspirit > 0 )); then
          if (( $mana > 2 )); then
            commander=1
            mana=$(($mana - 3))
          elif (( $mana == 2 && $hspirit > 0 )); then
            commander=1
            mana=$(($mana - 2))
            ((hspirit--))
          elif (( $mana == 1 && $hspirit > 1 )); then
            commander=1
            ((mana--))
            hspirit=$(($hspirit - 2))
          elif (( $mana == 0 && $hspirit > 2 )); then
            commander=1
            hspirit=$(($hspirit - 3))
          fi
        fi
        
        ## madness ##
        if (( $commander == 1 )) && (( $hmad > 0 || $mad > 0)); then
          if (( $hmad > 0 )); then
            while (( $hmad > 0 )); do
              ((hmad--))
            
              # Generate the random number, upper bound is library size to draw a card
              randomN=$((1 + $RANDOM % $library))
              # this will how we find the card we drew
              position=-1
              card=0
              
              while (( $card < $randomN )); do
                ((position++))
                card=$(( $card + ${deck[$position]} ))
              done
                ((deck[$position]--))
                ((library--))
              
              if (( $position == 0 )); then
                ((hlands++))
              elif (( $position == 1 )); then
                ((hshock++))
              elif (( $position == 2 )); then
                ((hfetch++))
              elif (( $position == 3 )); then
                ((hsol++))
              elif (( $position == 4 )); then
                ((hRCC2++))
              elif (( $position == 5 )); then
                ((hspirit++))
              elif (( $position == 6 )); then
                ((hmad++))
              elif (( $position == 7 )); then
                ((hCC1++))
              elif (( $position == 8 )); then
                ((hCC2++))
              elif (( $position == 9 )); then
                ((hCC3++))
              elif (( $position == 10 )); then
                ((hCC4++))
              elif (( $position == 11 )); then
                ((hCC5++))
              elif (( $position == 12 )); then
                ((hCC6++))
              else
                echo "error drawing a card"
              fi
            done
          elif (( $mad > 0 )); then
            ((mad--))
            
            # Generate the random number, upper bound is library size to draw a card
            randomN=$((1 + $RANDOM % $library))
            # this will how we find the card we drew
            position=-1
            card=0
            
            while (( $card < $randomN )); do
              ((position++))
              card=$(( $card + ${deck[$position]} ))
            done
            ((deck[$position]--))
            ((library--))
            
            if (( $position == 0 )); then
              ((hlands++))
            elif (( $position == 1 )); then
              ((hshock++))
            elif (( $position == 2 )); then
              ((hfetch++))
            elif (( $position == 3 )); then
              ((hsol++))
            elif (( $position == 4 )); then
              ((hRCC2++))
            elif (( $position == 5 )); then
              ((hspirit++))
            elif (( $position == 6 )); then
              ((hmad++))
            elif (( $position == 7 )); then
              ((hCC1++))
            elif (( $position == 8 )); then
              ((hCC2++))
            elif (( $position == 9 )); then
              ((hCC3++))
            elif (( $position == 10 )); then
              ((hCC4++))
            elif (( $position == 11 )); then
              ((hCC5++))
            elif (( $position == 12 )); then
              ((hCC6++))
            else
              echo "error drawing a card"
            fi
          fi
        fi
          
        ## mana rocks & extra mana ##
        if (( $commander == 1 && $hspirit > 0)); then
          while (( $hspirit > 0 )); do
            ((hspirit--))
            ((mana++))
          done
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
        
        ## mana efficiency ##
        while (( $mana > 0 )); do
          if (( $hCC6 > 0 && $mana > 5 )); then
            mana=$(($mana - 6))
            ((hCC6--))
          elif (( $hCC5 > 0 && $mana > 4 )); then
            mana=$(($mana - 5))
            ((hCC5--))
          elif (( $hCC4 > 0 && $mana > 3 )); then
            mana=$(($mana - 4))
            ((hCC4--))
          elif (( $hCC3 > 0 && $mana > 2 )); then
            mana=$(($mana - 3))
            ((hCC3--))
          elif (( $hCC2 > 0 && $mana > 1 )); then
            mana=$(($mana - 2))
            ((hCC2--))
          elif (( $hCC1 > 0 && $mana > 0 )); then
            ((mana--))
            ((hCC1--))
          else
            ((mana--))
            ((y++))
          fi
        done
        mana=$(($mana + $y))
        y=0
      
      elif (( $turn >= 6 )); then
        ((lost++))
        commander=1
      
      fi
      
      ##################################################
      
      mana_waste=$(($mana_waste + $mana))
      
    fi
    
done

if (( $turn <= 2 ));then
  ((turn2_deploy++))
elif (( $turn == 3 )); then
  ((turn3_deploy++))
elif (( $turn == 4 )); then
  ((turn4_deploy++))
elif (( $turn == 5 )); then
  ((turn5_deploy++))
else # (( $turn >= 6 )); then
  ((turn6p_deploy++))
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

echo "lost"
echo "scale=2 ; $lost / $sim_goal" | bc
echo ""

echo "% games with muligan"
echo "scale=3 ; $temp / $sim_goal" | bc
echo "percent breakdown"
echo "scale=3 ; $muliganC1 / $sim_goal" | bc
echo "scale=3 ; $muliganC2 / $sim_goal" | bc
echo "scale=3 ; $muliganC3 / $sim_goal" | bc

echo ""
echo "turn two $turn2_deploy"
echo "turn three $turn3_deploy"
echo "turn four $turn4_deploy"
echo "turn five $turn5_deploy"
echo "turn six+ $turn6p_deploy"
echo ""

finit=`date +%s`
runtime=$((finit-start))
echo "runtime $runtime"