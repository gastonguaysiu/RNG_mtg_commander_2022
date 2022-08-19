#!/bin/bash

# building a mtg mana probability distribution

start=`date +%s`

sim=0
sim_goal=10000

win=0
lost=0

all_drops=0

turn1_deploy=0
turn2_deploy=0
turn3_deploy=0
turn4_deploy=0
turn5_deploy=0

muliganC1=0
muliganC2=0
muliganC3=0

############################################################

while (( $sim < $sim_goal)); do
  # echo "muligan $muligan"
  # echo ""
  # echo "$sim"

reset=2

turn=-1
muligan=0
hand=0 #0 for unaccepted, 1 for accepter

mana_s=0
land_drop=0
game_lands=0

gold=0
mana=0
commander=0

tell=0
rage_s=0

new_hand=0
discard=0
draw=0
late_disc=0
end=0

loot_grave=0

x=0
y=0
z=0

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
        
        # section 1 of array has mana sources, element 0-7
        # lands, shocks, fetch, sol ring, gold, ritual, artifact ritual, CC0 sorcery
        deck=(15 3 2 1 2 5 5 2)
        
        # section 2 of array is for important single cards (8-12)
        # serum powder, final fortune, krark, burning prophet, dragon's rage
        deck=(${deck[@]} 0 1 0 0 1 )
        
        # section 3 is for combo pieces (13+ )
        # grinning ignus, storm combo,
        deck=(${deck[@]} 3 3 )
        
        # section 4 of array is the meat and bones
        # winds of change, faithless looting, burning inquiry, prophetic raving
        deck=(${deck[@]} 1 1 1 3 )
        # cathartic reunion, "wild guess", magmatic insight, cantrips, CC1, CC2
        deck=(${deck[@]} 1 3 0 10 0 0 )
        
        z=0
        for i in ${deck[@]}; do
          let z+=$i
        done
        
        if (( $z < $library )); then
          # echo "library too small in sync"
          other=$((99 - $z))
          deck[24]=$other
        elif (( $z > $library)); then
          echo "too many cards"
        fi
        z=0
        
        hlands=0
        hshock=0
        hfetch=0
        hsol=0
        
        hmana=0
        
        hgold=0
        hrit=0
        hart=0
        hsor=0
        
        hpowder=0
        hfinal=0
        hrage=0
        
        hignus=0
        hS=0
        
        hreunion=0
        hwild=0
        hinsight=0
        hcan=0
        
        hchange=0
        hloot=0
        hburn=0
        hraving=0
        
        
        hCC1=0
        hCC2=0
        
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
          ((hgold++))
        elif (( $position == 5 )); then
          ((hrit++))
        elif (( $position == 6 )); then
          ((hart++))
        elif (( $position == 7 )); then
          ((hsor++))
        
        elif (( $position == 8 )); then
          ((hpowder++))
        elif (( $position == 9 )); then
          ((hfinal++))
        elif (( $position == 12 )); then
          ((hrage++))
          
        elif (( $position == 13 )); then
          ((hignus++))
        elif (( $position == 14 )); then
          ((hS++))
        
        elif (( $position == 15 )); then
          ((hchange++))
        elif (( $position == 16 )); then
          ((hloot++))
        elif (( $position == 17 )); then
          ((hburn++))
        elif (( $position == 18 )); then
          ((hraving++))
        
        elif (( $position == 19 )); then
          ((hreunion++))
        elif (( $position == 20 )); then
          ((hwild++))
        elif (( $position == 21 )); then
          ((hinsight++))
        elif (( $position == 22 )); then
          ((hcan++))
        
        elif (( $position == 23 )); then
          ((hCC1++))
        elif (( $position == 24 )); then
          ((hCC2++))
        else
          echo "error drawing a card"
        fi
        hmana=$(($hlands + $hshock + $hfetch + $hsol + $hgold + $hrit))
      done
      
      if  (( muligan < 2 )); then
        # if it's a good hand keep, else muligan
        if (( (($hlands + $hshock + $hfetch)) > 1 )); then
          ((hand++))
        elif (( $hpowder == 1 )); then
          ((reset++))
        else # (( $hmana < 3 )); then
          ((muligan++))
          ((reset++))
        fi
      elif  (( muligan == 2 )); then
        if (( (($hlands + $hshock + $hfetch)) > 1 )); then
          ((hand++))
          x=1
        elif (( $hpowder == 1 )); then
          ((reset++))
        else # (( $hmana < 3 )); then
          ((muligan++))
          ((reset++))
        fi
      elif  (( muligan == 3 )); then
        if (( (($hlands + $hshock + $hfetch)) > 1 )); then
          ((hand++))
          x=2
        elif (( $hpowder == 1 )); then
          ((reset++))
        else # (( $hmana < 2 )); then
          ((hand++))
          turn=10
        fi
      fi
      
      # Discarding for muligan
      while (( $x > 0 )); do
      ((x--))
        if (( $hpowder > 0 )); then
          ((hpowder--))
          ((deck[8]++))
        elif (( $hmana > 3 && (($hlands + $hshock + $hfetch)) > 0 )); then
          if (( $hlands > 2 )); then
            ((hlands--))
            ((deck[0]++))
          elif (( $hfetch > 0 )); then
            ((hfetch--))
            ((deck[2]++))
          elif (( $hshock > 0 )); then
            ((hshock--))
            ((deck[1]++))
          elif (( $hsol == 1 )); then
            ((hsol--))
            ((deck[3]++))
          elif (( $hgold > 0 )); then
            ((hgold--))
            ((deck[4]++))
          elif (( $hrit > 0 )); then
            ((hrit--))
            ((deck[5]++))
          else
            echo "286"
          fi
        elif (( $hart > 1 || $hS > 1 || $hCC1 > 1 || $hCC2 > 1 )); then
          if (( $hart > 1 )); then
            ((hart--))
            ((deck[6]++))
          elif (( $hS > 1 )); then
            ((hS--))
            ((deck[4]++))
          elif (( $hCC1 > 1 )); then
            ((hCC1--))
            ((deck[23]++))
          elif (( $hCC2 > 1 )); then
            ((hCC2--))
            ((deck[24]++))
          else
          echo "error discarding double slot"
          fi
        else
          if (( $hCC1 > 0 )); then
            ((hCC1--))
            ((deck[23]++))
          elif (( $hCC2 > 0 )); then
            ((hCC2--))
            ((deck[24]++))
          elif (( $hfinal > 0 )); then
            ((hfinal--))
            ((deck[9]++))
          
          elif (( $hart > 0 )); then
            ((hart--))
            ((deck[6]++))
          elif (( $hsor > 0 )); then
            ((hsor--))
            ((deck[7]++))
          elif (( $hgold > 0 )); then
            ((hgold--))
            ((deck[4]++))
          elif (( $hrit > 0 )); then
            ((hrit--))
            ((deck[5]++))
          elif (( $hsol > 0 )); then
            ((hsol--))
            ((deck[3]++))
          
          elif (( $hraving > 0 )); then
            ((hraving--))
            ((deck[18]++))
          elif (( $hchange > 0 )); then
            ((hchange--))
            ((deck[15]++))
          elif (( $hburn > 0 )); then
            ((hburn--))
            ((deck[17]++))
          elif (( $hloot > 0 )); then
            ((hloot--))
            ((deck[16]++))
          
          elif (( $hreunion > 0 )); then
            ((hreunion--))
            ((deck[19]++))
          elif (( $hinsight > 0 )); then
            ((hinsight--))
            ((deck[20]++))
          elif (( $hwild > 0 )); then
            ((hwild--))
            ((deck[21]++))
          elif (( $hcan > 0 )); then
            ((hcan--))
            ((deck[22]++))
          
          elif (( $hrage > 0 )); then
            ((hrage--))
            ((deck[12]++))
          
          elif (( $hS > 0 )); then
            ((hS--))
            ((deck[14]++))
          elif (( $hignus > 0 )); then
            ((hignus--))
            ((deck[13]++))
          
          else
          echo "error discarding absolute"
          fi
        fi
        ((library++))
        hmana=$(($hlands + $hshock + $hfetch + $hsol + $hgold + $hrit))
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
      ((hgold++))
    elif (( $position == 5 )); then
      ((hrit++))
    elif (( $position == 6 )); then
      ((hart++))
    elif (( $position == 7 )); then
      ((hsor++))
    elif (( $position == 8 )); then
      ((hpowder++))
    elif (( $position == 9 )); then
      ((hfinal++))
    
    elif (( $position == 12 )); then
      ((hrage++))
    
    elif (( $position == 13 )); then
      ((hignus++))
    elif (( $position == 14 )); then
      ((hS++))
    
    elif (( $position == 15 )); then
      ((hchange++))
    elif (( $position == 16 )); then
      ((hloot++))
    elif (( $position == 17 )); then
      ((hburn++))
    elif (( $position == 18 )); then
      ((hraving++))
    
    elif (( $position == 19 )); then
      ((hreunion++))
    elif (( $position == 20 )); then
      ((hwild++))
    elif (( $position == 21 )); then
      ((hinsight++))
    elif (( $position == 22 )); then
      ((hcan++))
    
    elif (( $position == 23 )); then
      ((hCC1++))
    elif (( $position == 24 )); then
      ((hCC2++))
    else
      echo "error drawing a card $position"
    fi
    
    # play land
    if (( $hfetch > 0 )); then
      ((hfetch--))
      ((land_drop++))
      ((mana_s++))
      ((deck[0]--))
      ((library--))
    elif (( $hshock > 0 )); then
      ((hshock--))
      ((land_drop++))
      ((mana++))
      ((mana_s++))
      ((deck[0]--))
      ((library--))
    elif (( $hlands > 0 )); then
      ((hlands--))
      ((land_drop++))
      ((mana++))
      ((mana_s++))
    fi
    
    #### refine next step ###
    
    # turn 1 #
    if (( $turn == 1 )); then
      hmana=$(($hlands + $hshock + $hfetch + $hsol + $hrit))
      if (( $hsol == 1 && $mana > 0 )); then
        ((mana++))
        ((hsol--))
        mana_s=$(($mana_s + 2))
      elif (( $hgold > 0 && $mana > 0 )); then
        ((mana--))
        ((gold++))
      elif (( (($hmana + $mana_s)) < 3 && $hcan > 0 && $mana > 0 )); then
        ((mana--))
        ((hcan--))
        ((draw++))
      elif (( $hCC1 > 0 && $mana > 0 )); then
        ((hCC1--))
        ((mana--))
      fi
      
    ## turn 2 ##
    
    elif (( $turn == 2 )); then
      hmana=$(($hlands + $hshock + $hfetch + $hsol + $hrit))
      ## try to play commander ##
      if (( $commander == 0 )); then
        if (( (( $mana + $hrit + $gold)) > 2 )); then
          if (( $mana > 2 )); then
            commander=1
            mana=$(($mana - 3))
          
          elif (( $mana == 2 && $gold > 0 )); then
            commander=1
            mana=$(($mana - 2))
            ((gold--))
          elif (( $mana == 2 && $hrit > 0 )); then
            commander=1
            mana=$(($mana - 2))
            ((hrit--))
          
          elif (( $mana == 1 && $hrit > 0 && $gold > 0 )); then
            commander=1
            ((mana--))
            ((gold--))
            ((hrit--))
          elif (( $mana == 1 && $hrit > 1 )); then
            commander=1
            ((mana--))
            hrit=$(($hrit - 2))
          elif (( $mana == 1 && $gold > 1 )); then
            commander=1
            ((mana--))
            gold=$(($gold - 2))
          
          elif (( $mana == 0 && $gold > 2 )); then
            commander=1
            gold=$(($gold - 3))
          elif (( $mana == 0 && $gold > 1 && $hrit > 0 )); then
            commander=1
            gold=$(($gold - 2))
            ((hrit--))
          elif (( $mana == 0 && $gold > 0 && $hrit > 1 )); then
            commander=1
            hrit=$(($hrit - 2))
            ((gold--))
          elif (( $mana == 0 && $hrit > 2 )); then
            commander=1
            hrit=$(($hrit - 3))
          fi
        
        else # set up to play commander
          if (( $hsol == 1 && $mana > 0 )); then
            ((mana++))
            ((hsol--))
            mana_s=$(($mana_s + 2))
          elif (( $hgold > 0 && $mana > 0 )); then
            ((mana--))
            ((gold++))
          fi
        fi
        
      elif (( $hfinal == 1 && $mana > 1 )); then
        ((hfinal--))
        mana=$(($mana - 2))
        ((turn--))
        
        if (( $hrage == 1 && $mana > 0 )); then
          ((hrage--))
          rage_s=1
        fi
      
      elif (( (($hmana + $mana_s)) < 3 && $mana > 1 && $hreunion > 0 )); then
        mana=$(($mana - 2))
        ((hreunion--))
        discard=2
        draw=3
      elif (( (($hmana + $mana_s)) < 3 && $mana > 1 && $hwild > 0 )); then
        mana=$(($mana - 2))
        ((hwild--))
        discard=1
        draw=2
      elif (( (($hmana + $mana_s)) < 3 && $mana > 0 && $hcan > 0 )); then
        mana=$(($mana - 2))
        ((hcan--))
        draw=1
      
      fi
      
    
    elif (( $turn > 2 && $turn < 5 )); then
      
      ### try to play commander ###
      if (( $commander == 0 )); then
        if (( (( $mana + $hrit + $gold)) > 2 )); then
          if (( $mana > 2 )); then
            commander=1
            mana=$(($mana - 3))
          
          elif (( $mana == 2 && $gold > 0 )); then
            commander=1
            mana=$(($mana - 2))
            ((gold--))
          elif (( $mana == 2 && $hrit > 0 )); then
            commander=1
            mana=$(($mana - 2))
            ((hrit--))
          
          elif (( $mana == 1 && $hrit > 0 && $gold > 0 )); then
            commander=1
            ((mana--))
            ((gold--))
            ((hrit--))
          elif (( $mana == 1 && $hrit > 1 )); then
            commander=1
            ((mana--))
            hrit=$(($hrit - 2))
          elif (( $mana == 1 && $gold > 1 )); then
            commander=1
            ((mana--))
            gold=$(($gold - 2))
          
          elif (( $mana == 0 && $gold > 2 )); then
            commander=1
            gold=$(($gold - 3))
          elif (( $mana == 0 && $gold > 1 && $hrit > 0 )); then
            commander=1
            gold=$(($gold - 2))
            ((hrit--))
          elif (( $mana == 0 && $gold > 0 && $hrit > 1 )); then
            commander=1
            hrit=$(($hrit - 2))
            ((gold--))
          elif (( $mana == 0 && $hrit > 2 )); then
            commander=1
            hrit=$(($hrit - 3))
          fi
        
        else # set up to play commander
          if (( $hsol == 1 && $mana > 0 )); then
            ((mana++))
            ((hsol--))
            mana_s=$(($mana_s + 2))
          elif (( $hgold > 0 && $mana > 0 )); then
            ((mana--))
            ((gold++))
          fi
        fi
        
      elif (( $hfinal == 1 && $mana > 1 )); then
        ((hfinal--))
        mana=$(($mana - 2))
        ((turn--))
        
        if (( $hrage == 1 && $mana > 0 )); then
          ((hrage--))
          rage_s=1
        fi
      fi
      
      ### storm/combo ###
      if (( $commander == 1 && $mana > 0 )); then
        
        deck[6]=$((${deck[6]} + ${deck[4]}))
        deck[4]=0
        hart=$(($hart + $hgold))
        hgold=0
        
        while (( $end < 1 )); do
          
          N=0
          rage_trigger=0
          
          ### discard ###
          if (( $discard > 0 )); then
            while (( $discard > 0 )); do
              hmana_x=$(($hgold + $hart + $hsol*2 + $hrit*2 + $hsor))
              ((discard--))
              
              if (( $hlands > 0 )); then
                ((hlands--))
              elif (( $hfetch > 0 )); then
                ((hfetch--))
              elif (( $hshock > 0 )); then
                ((hshock--))
              elif (( $hpowder > 0 )); then
                ((hpowder--))
              elif (( $hfinal > 0 )); then
                ((hfinal--))
              
              elif (( $hCC2 > 0 )); then
                ((hCC2--))
              elif (( $hCC1 > 0 )); then
                ((hCC1--))
              
              elif (( $hS > 1 )); then
                ((hS--))
              
              elif (( (($mana + $hmana_x)) > 3 && $hmana_x > 0 ));then
                if (( $hart > 0 )); then
                  ((hart--))
                elif (( $hsol > 0 )); then
                  ((hsol--))
                elif (( $hrit > 0 )); then
                  ((hrit--))
                elif (( $hsor > 0 )); then
                  ((hsor--))
                else
                  echo "error mana disc"
                fi
              
              elif (( $hraving > 0 )); then
                ((hraving--))
              elif (( $hburn > 0 )); then
                ((hburn--))
              elif (( $hloot > 0 )); then
                ((hloot--))
              elif (( $hchange > 0 )); then
                ((hchange--))
              
              elif (( $hinsight > 0 )); then
                ((hinsight--))
              elif (( $hwild > 0 )); then
                ((hwild--))
              elif (( $hreunion > 0 )); then
                ((hreunion--))
              elif (( $hcan > 0 )); then
                ((hcan--))
              
              elif (( $hart > 0 )); then
                ((hart--))
              elif (( $hsol > 0 )); then
                ((hsol--))
              elif (( $hrit > 0 )); then
                ((hrit--))
              elif (( $hsor > 0 )); then
                ((hsor--))
              
              elif (( $hrage > 0 )); then
                ((hrage--))
              
              elif (( $hS > 0 )); then
                ((hS--))
              elif (( $hignus > 0 )); then
                ((hignus--))
              
              else
                echo "storm disc"
                echo "$hand_size"
              fi
            
            done
          fi
          
          ### draw ###
          if (( $draw > 0 )); then
            while (( $draw > 0)); do
              ((draw--))
              
              if (( tell == 0 )); then
                # Generate the random number, upper bound is library size to draw a card
                randomN=$((1 + $RANDOM % $library))
                # this how we find the card we drew
                position=-1
                card=0
                  
                while (( $card < $randomN )); do
                  ((position++))
                  card=$(( $card + ${deck[$position]} ))
                done
              else # (( tell == 1 )); then
                tell=0
              fi
              
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
              elif (( $position == 5 )); then
                ((hrit++))
              elif (( $position == 6 )); then
                ((hart++))
              elif (( $position == 7 )); then
                ((hsor++))
              elif (( $position == 8 )); then
                ((hpowder++))
              elif (( $position == 9 )); then
                ((hfinal++))
              
              elif (( $position == 12 )); then
                ((hrage++))
              
              elif (( $position == 13 )); then
                ((hignus++))
              elif (( $position == 14 )); then
                ((hS++))
              
              elif (( $position == 15 )); then
                ((hchange++))
              elif (( $position == 16 )); then
                ((hloot++))
              elif (( $position == 17 )); then
                ((hburn++))
              elif (( $position == 18 )); then
                ((hraving++))
              
              elif (( $position == 19 )); then
                ((hreunion++))
              elif (( $position == 20 )); then
                ((hwild++))
              elif (( $position == 21 )); then
                ((hinsight++))
              elif (( $position == 22 )); then
                ((hcan++))
              
              elif (( $position == 23 )); then
                ((hCC1++))
              elif (( $position == 24 )); then
                ((hCC2++))
              else
                echo "error drawing a card"
              fi
              
              if (( (($draw > 0 && $library < $draw)) || $library < 5 )); then
                end=1
                discard=0
                draw=0
                late_disc=0
              fi
            done
          fi
          
          ### late discard ###
          if (( $late_disc > 0 )); then
            while (( $late_disc > 0 )); do
              hmana_x=$(($hgold + $hart + $hsol*2 + $hrit*2 + $hsor))
              ((late_disc--))
              
              if (( $hlands > 0 )); then
                ((hlands--))
              elif (( $hfetch > 0 )); then
                ((hfetch--))
              elif (( $hshock > 0 )); then
                ((hshock--))
              elif (( $hpowder > 0 )); then
                ((hpowder--))
              elif (( $hfinal > 0 )); then
                ((hfinal--))
              
              elif (( $hCC2 > 0 )); then
                ((hCC2--))
              elif (( $hCC1 > 0 )); then
                ((hCC1--))
              
              elif (( $hCC1 > 1 )); then
                ((hCC1--))
              
              elif (( (($mana + $hmana_x)) > 3 && $hmana_x > 0 ));then
                if (( $hart > 0 )); then
                  ((hart--))
                elif (( $hsol > 0 )); then
                  ((hsol--))
                elif (( $hrit > 0 )); then
                  ((hrit--))
                elif (( $hsor > 0 )); then
                  ((hsor--))
                else
                  echo "error mana disc"
                fi
              
              elif (( $hraving > 0 )); then
                ((hraving--))
              elif (( $hburn > 0 )); then
                ((hburn--))
              elif (( $hloot > 0 )); then
                ((hloot--))
              elif (( $hchange > 0 )); then
                ((hchange--))
              
              elif (( $hinsight > 0 )); then
                ((hinsight--))
              elif (( $hwild > 0 )); then
                ((hwild--))
              elif (( $hreunion > 0 )); then
                ((hreunion--))
              elif (( $hcan > 0 )); then
                ((hcan--))
              
              elif (( $hart > 0 )); then
                ((hart--))
              elif (( $hsol > 0 )); then
                ((hsol--))
              elif (( $hrit > 0 )); then
                ((hrit--))
              elif (( $hsor > 0 )); then
                ((hsor--))
              
              elif (( $hrage > 0 )); then
                ((hrage--))
              
              elif (( $hS > 0 )); then
                ((hS--))
              elif (( $hignus > 0 )); then
                ((hignus--))
              
              else
                echo "error late_disc"
              fi
            
            done
          fi
          
          ### key cards CC1 ###
          if (( $hrage == 1 && $mana > 0 )); then
            ((hrage--))
            rage_s=1
          fi
          
          ### mana ###
          if (( $mana < 2 )); then
            if (( $hrit > 0 && $mana > 0 )); then
              ((hrit--))
              mana=$(($mana + 2))
            elif (( $hart > 0 )); then
              ((hart--))
              ((mana++))
            elif (( $hsor > 0 )); then
              ((hsor--))
              ((mana++))
            fi
          fi
          
          ### calculate hand size ###
          hand_size=$(($hlands + $hshock + $hfetch + $hsol + \
          $hrit + $hart + $hsor + $hpowder + $hfinal + $hrage + \
          $hloot + $hburn + $hraving + $hchange + \
          $hcan + $hinsight + $hwild + $hreunion  + \
          $hCC1 + $hCC2))
          
          # echo "stt $hand_size $mana $draw ... $hcan $hinsight $hwild $hreunion . $hchange $hloot $hburn $hraving .. $rage_s"
          
          ##############################################################
          
          ### cantrips ###
          if (( $hcan > 0 && $mana > 0 )); then
            ((hcan--))
            ((draw++))
            if (( $rage_s == 1 )); then
              rage_trigger=1
            fi
          
          ## wheel "wild guess" ##
          elif (( $hwild > 0 && $mana > 1 && $hand_size > 1 )); then
            ((hwild--))
            ((mana--))
            ((discard++))
            draw=2
            if (( $rage_s == 1 )); then
              rage_trigger=1
            fi
          
          ### wheel "cathartic reunion" ###
          elif (( $hreunion > 0 && $mana > 1 && $hand_size > 2 )); then
            ((hreunion--))
            ((mana--))
            discard=2
            draw=3
            if (( $rage_s == 1 )); then
              rage_trigger=1
            fi
          
          ## wheel "faithless looting" ##
          elif (( $hloot > 0 && $mana > 0 )); then
            ((hloot--))
            loot_grave=1
            draw=2
            late_disc=2
            if (( $rage_s == 1 )); then
              rage_trigger=1
            fi
          
          ## wheel "burning inquiry" ##
          elif (( $hburn > 0 && $mana > 0 )); then
            ((hburn--))
            draw=3
            late_disc=3
            if (( $rage_s == 1 )); then
              rage_trigger=1
            fi
          
          ## wheel "faithless looting flashback" ##
          elif (( $loot_grave > 0 && (($mana + $hrit*2 + $hart + $hsor)) > 2 )); then
            
            if (( $mana < 2 )); then
              if (( $hrit > 0 && $mana > 0 )); then
                ((hrit--))
                mana=$(($mana + 2))
              elif (( $hsor > 0 )); then
                ((hsor--))
                ((mana++))
              elif (( $hart > 0 )); then
                ((hart--))
                ((mana++))
              fi
            fi
            
            ((loot_grave--))
            mana=$(($mana - 2))
            draw=2
            late_disc=2
            if (( $rage_s == 1 )); then
              rage_trigger=1
            fi
          
          ## wheel "winds of change" ##
          elif (( $hchange > 0 && $mana > 0 && $hand_size > 2 )); then
            ((hchange--))
            new_hand=1
            if (( $rage_s == 1 )); then
              rage_trigger=1
            fi
            
          ## wheel "prophetic raving" ##
          elif (( $hraving > 0 && $mana > 0 && $hand_size > 1 )); then
            ((hraving--))
            discard=1
            draw=1
          
          else
            end=1
            # echo "endgame $hand_size $mana $draw ... $hcan $hinsight $hwild $hreunion . $hchange $hloot $hburn $hraving .. $rage_s"
          fi
          
          ####################################################################
            
          ## triggers && combo ##
          
          if (( $rage_trigger == 1 && $tell == 0 && $library > 0 )); then
            randomN=$((1 + $RANDOM % $library))
            position=-1
            card=0
            while (( $card < $randomN )); do
              ((position++))
              card=$(( $card + ${deck[$position]} ))
            done
            
            if (( $position < 10 || $position > 19 )); then
              ((deck[$position]--))
              ((library--))
              tell=0
            else
              tell=1
            fi
          fi
            
          if (( $new_hand == 1 )); then
            discard=$(($hand_size - 1))
            draw=$(($draw + $hand_size - 1))
            new_hand=0
          fi
          
          if (( $library == 0 )); then
            end=1
          fi
          
          ## win combo ##
          if (( $hignus > 0 && $hS > 0 && (($mana + $hrit*2 + $hart + $hsor)) > 2 )); then
            # ending game, shorthand don't add mana
            end=1
            # echo "win"
          fi
          
          ### calculate hand size ###
          hand_size=$(($hlands + $hshock + $hfetch + $hsol + \
          $hrit + $hart + $hsor + $hpowder + $hfinal + $hrage + \
          $hloot + $hburn + $hraving + $hchange + \
          $hcan + $hinsight + $hwild + $hreunion  + \
          $hCC1 + $hCC2))
          
          # echo "end $hand_size $mana $draw ... $hcan $hinsight $hwild $hreunion . $hchange $hloot $hburn $hraving .. $rage_s"
          
        done
      fi
    
    elif (( $turn >= 5 )); then
      ((end++))
      ((lost++))
      commander=1
      # echo "lost"
      
    fi
    
    #################################################################3
    
    ## draw/discard w/o commander ##
    if (( (($discard + $draw + $late_disc)) > 0 && $commander < 1 )); then
      
      ## discard w/o commander ##
      if (( $discard > 0 )); then
        while (( $discard > 0 )); do
        ((discard--))
        
        if (( $hCC2 > 0 )); then
          ((hCC2--))
        elif (( $hCC1 > 0 )); then
          ((hCC1--))
        elif (( $hpowder > 0 )); then
          ((hpowder--))
        elif (( $hfinal > 0 )); then
          ((hfinal--))
        
        elif (( $hS > 1 )); then
          ((hS--))
        
        elif (( $hart > 0 )); then
          ((hart--))
        elif (( $hsor > 0 )); then
          ((hsor--))
        
        elif (( $hraving > 0 )); then
          ((hraving--))
        elif (( $hburn > 0 )); then
          ((hburn--))
        elif (( $hloot > 0 )); then
          ((hloot--))
        elif (( $hchange > 0 )); then
          ((hchange--))
        
        elif (( $hinsight > 0 )); then
          ((hinsight--))
        elif (( $hwild > 0 )); then
          ((hwild--))
        elif (( $hreunion > 0 )); then
          ((hreunion--))
        elif (( $hcan > 0 )); then
          ((hcan--))
        
        elif (( $hrage > 0 )); then
          ((hrage--))
        
        elif (( $hS > 0 )); then
          ((hS--))
        elif (( $hignus > 0 )); then
          ((hignus--))
        
        elif (( $hrit > 0 )); then
          ((hrit--))
        elif (( $hgold > 0 )); then
          ((hgold--))
        elif (( $hfetch > 0 )); then
          ((hfetch--))
        elif (( $hlands > 0 )); then
          ((hlands--))
        elif (( $hshock > 0 )); then
          ((hshock--))
        elif (( $hsol > 0 )); then
          ((hsol--))
          
        else
          echo "turn 1, 2 discard problem"
          echo "$hand_size"
        fi
            
        done
      fi
          
      ## draw w/o commander ##
      if (( $draw > 0 )); then
        while (( $draw > 0)); do
        ((draw--))
        
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
          ((hgold++))
        elif (( $position == 5 )); then
          ((hrit++))
        elif (( $position == 6 )); then
          ((hart++))
        elif (( $position == 7 )); then
          ((hsor++))
        
        elif (( $position == 8 )); then
          ((hpowder++))
        elif (( $position == 9 )); then
          ((hfinal++))
        elif (( $position == 12 )); then
          ((hrage++))
        
        elif (( $position == 13 )); then
          ((hignus++))
        elif (( $position == 14 )); then
          ((hS++))
        
        elif (( $position == 15 )); then
          ((hchange++))
        elif (( $position == 16 )); then
          ((hloot++))
        elif (( $position == 17 )); then
          ((hburn++))
        elif (( $position == 18 )); then
          ((hraving++))
        
        elif (( $position == 19 )); then
          ((hreunion++))
        elif (( $position == 20 )); then
          ((hwild++))
        elif (( $position == 21 )); then
          ((hinsight++))
        elif (( $position == 22 )); then
          ((hcan++))
        
        elif (( $position == 23 )); then
          ((hCC1++))
        elif (( $position == 24 )); then
          ((hCC2++))
        else
          echo "turn 1, 2 draw error"
        fi
        
        done
      fi
          
      ## late discard w/o commander ##
      if (( $late_disc > 0 )); then
        while (( $late_disc > 0 )); do
        ((late_disc--))
        
        if (( $hCC2 > 0 )); then
          ((hCC2--))
        elif (( $hCC1 > 0 )); then
          ((hCC1--))
        elif (( $hpowder > 0 )); then
          ((hpowder--))
        elif (( $hfinal > 0 )); then
          ((hfinal--))
        
        elif (( $hS > 1 )); then
          ((hS--))
        
        elif (( $hart > 0 )); then
          ((hart--))
        elif (( $hsor > 0 )); then
          ((hsor--))
        
        elif (( $hraving > 0 )); then
          ((hraving--))
        elif (( $hburn > 0 )); then
          ((hburn--))
        elif (( $hloot > 0 )); then
          ((hloot--))
        elif (( $hchange > 0 )); then
          ((hchange--))
        
        elif (( $hinsight > 0 )); then
          ((hinsight--))
        elif (( $hwild > 0 )); then
          ((hwild--))
        elif (( $hreunion > 0 )); then
          ((hreunion--))
        elif (( $hcan > 0 )); then
          ((hcan--))
        
        elif (( $hrage > 0 )); then
          ((hrage--))
        
        elif (( $hS > 0 )); then
          ((hS--))
        elif (( $hignus > 0 )); then
          ((hignus--))
        
        elif (( $hrit > 0 )); then
          ((hrit--))
        elif (( $hgold > 0 )); then
          ((hgold--))
        elif (( $hfetch > 0 )); then
          ((hfetch--))
        elif (( $hlands > 0 )); then
          ((hlands--))
        elif (( $hshock > 0 )); then
          ((hshock--))
        elif (( $hsol > 0 )); then
          ((hsol--))
          
        else
          echo "turn 1, 2 late_disc problem"
          echo "$hand_size"
        fi
            
        done
      fi
      
      ## late land drop ##
      if (( $land_drop == 0 && (($hfetch + $hshock + $hlands)) > 0 )); then
        if (( $hfetch > 0 )); then
          ((hfetch--))
          ((land_drop++))
          ((mana_s++))
          ((deck[0]--))
          ((library--))
        elif (( $hshock > 0 )); then
          ((hshock--))
          ((land_drop++))
          ((mana++))
          ((mana_s++))
          ((deck[0]--))
          ((library--))
        elif (( $hlands > 0 )); then
          ((hlands--))
          ((land_drop++))
          ((mana++))
          ((mana_s++))
        fi
      fi
      
    fi
    
    ### count land drops ###
    
    if (( $land_drop == 1 )); then
      ((game_lands++))
    elif (( $land_drop > 1 )); then
      echo " land drop error"
    fi
    
  fi
  
done

if (( $game_lands == $turn )); then
  ((all_drops++))
elif (( $game_lands > $turn )); then
  echo "final fortune"
fi

if (( $turn == 1 ));then
  ((turn1_deploy++))
elif (( $turn == 2 )); then
  ((turn2_deploy++))
elif (( $turn == 3 )); then
  ((turn3_deploy++))
elif (( $turn == 4 )); then
  ((turn4_deploy++))
elif (( $turn == 5 )); then
  ((turn5_deploy++))
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

finit=`date +%s`
runtime=$((finit-start))
echo "runtime --- $runtime"
echo ""

echo "lost"
echo "scale=4 ; $lost / $sim_goal" | bc

echo "all land drops"
echo "scale=3 ; $all_drops / $sim_goal" | bc
echo ""

echo "% games with muligan"
echo "scale=3 ; $temp / $sim_goal" | bc
echo "percent breakdown"
echo "scale=3 ; $muliganC1 / $sim_goal" | bc
echo "scale=3 ; $muliganC2 / $sim_goal" | bc
echo "scale=3 ; $muliganC3 / $sim_goal" | bc

echo ""
# echo "turn one $turn1_deploy"
echo "turn two $turn2_deploy"
echo "turn three $turn3_deploy"
echo "turn four $turn4_deploy"
echo "turn five $turn5_deploy"