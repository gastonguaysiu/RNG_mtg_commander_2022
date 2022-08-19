#!/bin/bash

# building a mtg mana probability distribution

sim=0
sim_goal=10000

turn2_deploy=0
turn3_deploy=0
turn4_deploy=0
turn5_deploy=0
turn6p_deploy=0

muliganC1=0
muliganC2=0
muliganC3=0

first_blood=0

while (( $sim < $sim_goal)); do

reset=0
library=99
count=0

lands=21
shock=2
fetch=0

#mana rocks
# RCC1
sol=1
amulet=1
rmap=1
sac_m=0
# RCC2
sphere=0
science=0
RCC2=0 # 4 colored & 4 non-colored exist that don't come in tapped

first=0

mk1a=$(($lands + $shock))
mk1b=$(($mk1a + $fetch + $sol))
mk1c=$(($mk1b + $amulet + $rmap))
mk1d=$(($mk1c + $sac_m))
mk2a=$(($mk1d + $science + $sphere))
mk2b=$(($mk2a + $RCC2))

tab1=$(($mk2b + $first))
other=$(($library - $tab1))

hlands=0
hshock=0
hfetch=0
hsol=0
hrmap=0
hamulet=0
hsac_m=0
hsphere=0
hscience=0
hRCC2=0
hmana=0

hfirst=0
hother=0

turn=-1
muligan=0
hand=0 #0 for unaccepted, 1 for accepter

mana_s=0
land_drop=0

# 1:land, 2:other
scry=0

rmap_s=0
amulet_s=0
sphere_s=0

mana=0
commander=0
x=0
y=0

while (( $commander < 1 )); do
  ((turn++))

    # we are in the draw step
    if (( $turn == 0 )); then
    
      while [[ hand -lt 1 ]]; do
        while (( count < 7 )); do
          ((count++))
          # Generate the random number, upper bound is library size to draw a card
          randomN=$((1 + $RANDOM % $library))
          
          if (( $randomN <= $lands )); then
            ((hlands++))
            ((lands--))
          elif (( $randomN > $lands && $randomN <= $mk1a )); then
            ((hshock++))
            ((shock--))
          elif (( $randomN > $mk1a && $randomN == $mk1b && $sol == 1 )); then
            ((hsol++))
            ((sol--))
          elif (( $randomN > $mk1a && $randomN <= $mk1b )); then
            ((hfetch++))
            ((fetch--))
          elif (( $randomN > $mk1b && $randomN == $mk1c && $rmap == 1 )); then
            ((hrmap++))
            ((rmap--))
          elif (( $randomN > $mk1b && $randomN <= $mk1c )); then
            ((hamulet++))
            ((amulet--))
          elif (( $randomN > $mk1c && $randomN <= $mk1d )); then
            ((hsac_m++))
            ((sac_m--))
          elif (( $randomN > $mk1d && $randomN == $mk2a && $sphere == 1 )); then
            ((hsphere++))
            ((sphere--))
          elif (( $randomN > $mk1d && $randomN <= $mk2a )); then
            ((hscience++))
            ((science--))
          elif (( $randomN > $mk2a && $randomN <= $mk2b )); then
            ((hRCC2++))
            ((RCC2--))
          elif (( $randomN > $mk2b && $randomN <= $tab1 )); then
            ((hfirst++))
            ((first--))
          else # (( $randomN > $mk1b && $randomN <= $tab1 )); then
            ((hother++))
            ((other--))
          fi
          ((library--))
          mk1a=$(($lands + $shock))
          mk1b=$(($mk1a + $fetch + $sol))
          mk1c=$(($mk1b + $amulet + $rmap))
          mk1d=$(($mk1c + $sac_m))
          mk2a=$(($mk1d + $science + $sphere))
          mk2b=$(($mk2a + $RCC2))
          
          tab1=$(($mk2b + $first))
          other=$(($library - $tab1))
          
          # y=$(($hsphere + $hscience + $hRCC2))
          hmana=$(($hlands + $hshock + $hfetch + $hsol + $hrmap + $hamulet + $y))
          
        done
          
        if  (( muligan < 2 )); then
          # if it's a good hand keep, else muligan
          if (( $hmana > 1 && $hmana < 5 )) && (( $hlands > 0 || $hshock > 0 )); then
            ((hand++))
          else
            ((muligan++))
            ((reset++))
          fi
        elif  (( muligan == 2 )); then
          # if it's a good hand keep, else muligan
          if (( $hmana > 1 && $hmana < 5 )) && (( $hlands > 0 || $hshock > 0 )); then
            ((hand++))
            x=1
          else
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
          if (( $hmana >= 1 && $hmana < 4 && $hlands > 0 && $x == 1 )); then
            ((hlands--))
            scry=1
          elif (( $hmana > 4 && $hlands > 0 )); then
            if (( $hfetch > 0 )); then
              ((hfetch--))
              ((fetch++))
            elif (( $hscience > 0 )); then
              ((hscience--))
              ((science++))
            elif (( $hsphere == 1 )); then
              ((hsphere--))
              ((sphere++))
            elif (( $hamulet == 1 )); then
              ((hamulet--))
              ((amulet++))
            elif (( $hrmap == 1 )); then
              ((hrmap--))
              ((rmap++))
            elif (( $hshock > 0 )); then
              ((hshock--))
              ((shock++))
            elif (( $hRCC2 > 0 )); then
              ((hRCC2--))
              ((RCC2++))
            elif (( $hsol == 1 )); then
              ((hsol--))
              ((sol++))
            elif (( $hlands > 2 )); then
              ((hlands--))
              ((lands++))
            else
              echo "error"
            fi
          elif (( $hfirst > 1 )); then
            ((hfirst++))
            ((first--))
          else # (( $hother > 0 )); then
            ((hother--))
            ((other++))
          fi
          ((library--))
          mk1a=$(($lands + $shock))
          mk1b=$(($mk1a + $fetch + $sol))
          mk1c=$(($mk1b + $amulet + $rmap))
          mk1d=$(($mk1c + $sac_m))
          mk2a=$(($mk1d + $science + $sphere))
          mk2b=$(($mk2a + $RCC2))
          
          tab1=$(($mk2b + $first))
          other=$(($library - $tab1))
          
          # y=$(($hsphere + $hscience + $hRCC2))
          hmana=$(($hlands + $hshock + $hfetch + $hsol + $hrmap + $hamulet + $y))
          
        done
            
        # reset hand and library if needed
        if (( reset == 1 ));then
          # echo "discarding $hmana lands, muligan $muligan"
          # echo ""
          
          reset=0
          library=99
          count=0
          
          lands=21
          shock=2
          fetch=0
          
          #mana rocks
          # RCC1
          sol=1
          amulet=1
          rmap=1
          sac_m=0
          # RCC2
          sphere=0
          science=0
          RCC2=0 # 4 colored & 4 non-colored exist that don't come in tapped
          
          first=0
          
          mk1a=$(($lands + $shock))
          mk1b=$(($mk1a + $fetch + $sol))
          mk1c=$(($mk1b + $amulet + $rmap))
          mk1d=$(($mk1c + $sac_m))
          mk2a=$(($mk1d + $science + $sphere))
          mk2b=$(($mk2a + $RCC2))
          
          tab1=$(($mk2b + $first))
          other=$(($library - $tab1))
          
          hlands=0
          hshock=0
          hfetch=0
          hsol=0
          hrmap=0
          hamulet=0
          hsac_m=0
          hsphere=0
          hscience=0
          hRCC2=0
          hmana=0
          
          hfirst=0
          hother=0
        fi
        
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
          ((hshock++))
          ((shock--))
        elif (( $randomN > $mk1a && $randomN == $mk1b && $sol == 1 )); then
          ((hsol++))
          ((sol--))
        elif (( $randomN > $mk1a && $randomN <= $mk1b )); then
          ((hfetch++))
          ((fetch--))
        elif (( $randomN > $mk1b && $randomN == $mk1c && $rmap == 1 )); then
          ((hrmap++))
          ((rmap--))
        elif (( $randomN > $mk1b && $randomN <= $mk1c )); then
          ((hamulet++))
          ((amulet--))
        elif (( $randomN > $mk1c && $randomN <= $mk1d )); then
          ((hsac_m++))
          ((sac_m--))
        elif (( $randomN > $mk1d && $randomN == $mk2a && $sphere == 1 )); then
          ((hsphere++))
          ((sphere--))
        elif (( $randomN > $mk1d && $randomN <= $mk2a )); then
          ((hscience++))
          ((science--))
        elif (( $randomN > $mk2a && $randomN <= $mk2b )); then
          ((hRCC2++))
          ((RCC2--))
        elif (( $randomN > $mk2b && $randomN <= $tab1 )); then
          ((hfirst++))
          ((first--))
        else # (( $randomN > $mk1b && $randomN <= $tab1 )); then
          ((hother++))
          ((other--))
        fi
        ((library--))
        mk1a=$(($lands + $shock))
        mk1b=$(($mk1a + $fetch + $sol))
        mk1c=$(($mk1b + $amulet + $rmap))
        mk1d=$(($mk1c + $sac_m))
        mk2a=$(($mk1d + $science + $sphere))
        mk2b=$(($mk2a + $RCC2))
        
        tab1=$(($mk2b + $first))
        other=$(($library - $tab1))
        
      else # (( scry == 1 )); then
        ((hlands++))
        ((library--))
        scry=0
      fi
        
      # rocks=$(($hsol))
      # fetch=$(($hrmap + $hamulet + $hscience + $sphere))
      # echo "starting turn $turn with $hlands lands"
      # echo "and $rocks rocks in hand"
      # echo "and $fetch fetches in hand"
      
      # play land
      if (( $hlands > 0 && $turn == 1 )); then
        ((hlands--))
        ((land_drop++))
        ((mana++))
        ((mana_s++))
      elif (( $hshock > 0 )) && (( $hlands == 0 || $turn > 2 )); then
        ((lands--))
        ((hshock--))
        ((land_drop++))
        ((mana++))
        ((mana_s++))
        ((library--))
        mk1a=$(($lands + $shock))
        mk1b=$(($mk1a + $fetch + $sol))
        mk1c=$(($mk1b + $amulet + $rmap))
        mk1d=$(($mk1c + $sac_m))
        mk2a=$(($mk1d + $science + $sphere))
        mk2b=$(($mk2a + $RCC2))
        tab1=$(($mk2b + $first))
        other=$(($library - $tab1))
      elif (( $hfetch > 0 && $hlands == 0 )) || [[ $hfetch -gt 0 && $mana_s -ne 1 && $hlands -gt 0 ]]; then
        if (( $mana_s == 1 && $hlands > 0 )); then
          echo "error line 352"
        fi
        ((lands--))
        ((hfetch--))
        ((land_drop++))
        ((mana_s++))
        ((library--))
        mk1a=$(($lands + $shock))
        mk1b=$(($mk1a + $fetch + $sol))
        mk1c=$(($mk1b + $amulet + $rmap))
        mk1d=$(($mk1c + $sac_m))
        mk2a=$(($mk1d + $science + $sphere))
        mk2b=$(($mk2a + $RCC2))
        tab1=$(($mk2b + $first))
        other=$(($library - $tab1))
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
          ((first_blood++))
        elif (( $hsol && $mana > 0 )); then
          ((mana++))
          ((hsol--))
          ((mana_s++))
          ((mana_s++))
          if (( $hRCC2 > 0 && $mana > 1 )); then
            ((mana--))
            ((hRCC2--))
            ((mana_s++))
          fi
        fi
        if (( $hrmap == 1 && $mana > 0 )); then
          ((mana--))
          ((hrmap--))
          ((rmap_s++))
        elif (( $hamulet == 1 && $mana > 0 )); then
          ((mana--))
          ((hamulet--))
          ((amulet_s++))
        fi
      fi
      
      if (( $turn >= 2 )); then
        if (( $rmap_s == 1 )); then
          ((rmap_s--))
          ((hlands++))
          ((lands--))
          ((library--))
          if (( $land_drop == 0 )); then
            ((hlands--))
            ((land_drop++))
            ((mana++))
            ((mana_s++))
          fi
        fi
        if (( $mana > 1 )); then
          ((commander++))
          mana=$(($mana - 2))
        fi
        if (( $mana > 0 )); then
          if (( $hRCC2 > 0 && $mana > 1 )); then
            ((mana--))
            ((hRCC2--))
            ((mana_s++))
          fi
          if (( $hsphere > 0 && $mana > 1 )); then
            mana=$(($mana - 2))
            ((hsphere--))
            ((sphere_s++))
          fi
          if (( $sphere_s == 1 && $mana > 1 )); then
            mana=$(($mana - 2))
            ((sphere_s--))
            hlands=$(($hlands + 2))
            lands=$(($lands - 2))
            library=$(($library - 2))
          fi
          if (( $hscience > 0 && $mana > 1 )); then
            ((hscience--))
            ((hlands--))
            ((lands--))
            ((library--))
          fi
          if (( $hamulet == 1 && $mana > 0 )); then
            ((mana--))
            ((hamulet--))
            ((amulet_s++))
          fi
          if (( $amulet_s == 1 && $mana > 0 )); then
            ((mana--))
            ((amulet_s--))
            ((hlands++))
            ((lands--))
            ((library--))
          fi
          if (( $hrmap == 1 && $mana > 1 )); then
            ((mana--))
            ((hrmap--))
            ((rmap_s++))
          fi
        fi
        mk1a=$(($lands + $shock))
        mk1b=$(($mk1a + $fetch + $sol))
        mk1c=$(($mk1b + $amulet + $rmap))
        mk1d=$(($mk1c + $sac_m))
        mk2a=$(($mk1d + $science + $sphere))
        mk2b=$(($mk2a + $RCC2))
        tab1=$(($mk2b + $first))
        other=$(($library - $tab1))
        if (( $hlands > 0 && $land_drop == 0 )); then
          ((hlands--))
          ((land_drop++))
          ((mana++))
          ((mana_s++))
        fi
      fi
      
      # echo "ending turn $turn with $mana_s mana sources on board"
      # echo ""
      
    fi
    
done

# echo "you needed $turn turns & $muligan muligans to get $mana mana sources"

if (( $turn == 2 ));then
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

echo "% first blood"
echo "scale=3 ; $first_blood / $sim_goal" | bc
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
