# Coordinated Multiple Views Visualization
Visualize 2016 presidential primary campaign contributions with a coordinated 
multiple views visualization written in Processing3. The visualization includes
a line graph, pie chart, and cartogram which each emphasize a different aspect
of the data. Actions such as highlight on hover and click to filter coordinate 
accross all three visualizations.

## Line Graph
The line graph shows cumulative campaign contributions by month. Clicking on a 
month filters contents of the pie graph. Hovering over a line reveals the label
of the candidate corresponding to that line, highlights the corresponding slice 
in the pie chart, and highlights the candidate's state of residence in the 
cartogram.

## Pie Chart
The pie chart shows the proportion of donations that each candidate has received. 
Clicking on a month in the line graph filters the pie chart to show the proportion  
of total contributions made to each candidate up to the month selected. To filter 
the pie chart by candidates' state of residence, click on a state in the cartogram. 
Hovering over a slice of the chart reveals the label of the candidate 
corresponding to that slice, highlights the corresponding line in the line graph,  
and highlights the candidate's state of residence in the cartogram.

## Cartogram
The cartogram shows, for each state, the political parties to which candidates
from that state belong. Left click on a state to filter the pie graph to show 
only the candidates from that state. Right click to release the filter. 
Hovering over a state reveals labels for all of the candidates who reside in that
state, and highlights the corresponding lines in the line graph and the
corresponding slices in the pie chart. 

## How to run
To run, open processing3 and run the file, 'cmv.pde'.
