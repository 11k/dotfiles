# Symbols
ARROW="\u203a" # ›
BOTTOM_LEFT_CORNER="\u2514" # └
TOP_RIGHT_CORNER="\u250c" # ┌
HORIZONTAL_LINE="\u2500" # ─
SUI="\u7c8b" # 粋

# Colors
LIGHT_GRAY=$FG[251]
DIM_GRAY=$FG[237]
BRIGHT_WHITE=$FG[231]
VIOLET=$FG[170]
GREEN=$FG[035]

# Git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX=" $BRIGHT_WHITE$(echo $ARROW) $LIGHT_GRAY"
ZSH_THEME_GIT_PROMPT_DIRTY=" $BRIGHT_WHITE$(echo $ARROW) $LIGHT_GRAY*"
ZSH_THEME_GIT_PROMPT_SUFFIX=""

function createDivider {
  local LINES_TO_PRINT
  ((LINES_TO_PRINT=$COLUMNS - 1))

  local DIVIDER=""
  for i in {1..$LINES_TO_PRINT}; do
    DIVIDER="$DIVIDER$HORIZONTAL_LINE"
  done

  echo $DIVIDER
}

PS1='$DIM_GRAY$(echo $TOP_RIGHT_CORNER)$(createDivider)
$(echo $BOTTOM_LEFT_CORNER) $LIGHT_GRAY%~$(git_prompt_info) $VIOLET$(echo $ARROW)%{$reset_color%} '
RPS1='$DIM_GRAY$(echo $SUI)%{$reset_color%}'

PS2='$DIM_GRAY$(echo $BOTTOM_LEFT_CORNER) $VIOLET$(echo $ARROW) %{$reset_color%}'
