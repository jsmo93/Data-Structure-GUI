# Milestone 1 README
### Milestone 1 Requirements:
* Completed diagram components - Found in Diagram-Components.rkt
* Completed drawing procedures - Found in Diagram-Drawing.rkt
* List of defined steps for drawing - Provided below
* List of defined steps for saving - Provided below
* List of defined steps for resolving collisions - Provided below

### Data Structure GUI:
1. Convert provided DS into a table of elements
  1. Iterate through DS. For every car, increase row count by 1. For every cdr increase col count by one. Use helper functions to classify the element based on car/cdr vals and save parent info.
  2. Determine the maximum row count and maximum collumn count in the table.
  3. Re-iterate through the DS and now increase row count by max-row and col-count by max col for each entry. This eliminates all possible collisions by adding lots of extra space.
  4. Use table-sort procedure to sort the table by row, then column.
  5. Iterate through the table and remove empty rows and columns to compress the diagram.
2. Iterate over the table elements and draw the diagram grid
  1. Use the element-type field and the cell's row and column information to draw the appropriate elments in the appropriate cells. Use the provided drawing procedures.
3. Accept user changes to diagram
  1. Implementation tbd
4. Decompose the diagram into an updated table of elements
  1. Iterate through each cell of the diagram, create the table again based on cars and cdrs.
  2. Use the same procedures from (1b-1e) to create a properly spaced diagram.
5. Decompose the table of elements into a data structure
  1. Iterate through the table, applying cons to the elements car and cdr cells. The function will be evaluating cells until it hits a data element or null element, at which point it can actually work its way back up the recursive call chain and assemble the structure from the bottom up.
6. Set the old data structure's binding to the new data structure's binding

### Additional Files:
* Table-Utils.rkt - Contains working table-sort procedure and accessors for table elements
* OPL-Project.rkt - Currently a scratchpad to test drawing functions and view diagram layouts
