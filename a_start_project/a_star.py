import dists as dt
import sys

# Algorithm to find the best way to Bucharest.
# Author: Samuel Kojicovski <kojicovski@gmail.com>

def children(parent):
    """Return <list> children of a given parent"""
    return (list(children for children in dt.dists[parent[0]]))
    
def sort_method(n):
    """Return lenght path"""
    return n[1]

def sort_list(border):
    """It sorts border_list<listt> by lenght path"""
    border.sort(key = sort_method)
    
def objective_test(current, goal):
    """
        It checks if current node is goal
        return: <boolean>
    """
    return (current[0] == goal)

def in_list(item, current_list):
    """
       It checks there are child in current_list
       return <boolean>
    """
    for i in current_list:
        if(i[0] == item[0]):
            return True
    return False

def a_star(start, goal='Bucharest'):
    """
        Main function: start algoritm to find lower path
        arg[0]: start
        arg[1]: goal
        return: <list>
    """
    start_node = start
    border_list = [start_node]
    explored_list = []  
    distance = {start[0]: start[1]}
    solution_dict = {}  
    father_node = None
    
    
    while True:
        if len(border_list) == 0:
            return 'Fail! The border list is empty'
        
        # Get the most priority item from border list and append it in the 
        # solution list
        current_node = border_list.pop(0)

        # Check if the current node is the goal
        if objective_test(current_node, goal):
            way_list = []           
            current = goal

            for k in reversed(solution_dict.items()):
                if current in solution_dict.keys():
                    current = solution_dict[current]
                    way_list.append(current)

            way_list.insert(0, goal)
            return print(f"Final path:{list(reversed(way_list))}")
        
        # Add the current node to explored list
        explored_list.append(current_node)
            
        # For each child of this node, do:
        for child in children(current_node):            
            g_cost = distance[current_node[0]] + child[1]
            h_cost = dt.straight_line_dists_from_bucharest[child[0]]
            f_cost = g_cost + h_cost            
            
            in_border_list = in_list(child, border_list)
            in_explored_list = in_list(child, explored_list)
            
            if in_border_list == False and in_explored_list == False:  
                father_node = current_node[0]                
                border_list.append((child[0], f_cost, father_node))
                solution_dict[child[0]] = current_node[0]
            elif in_border_list == True:
                for item in border_list:                    
                    if(item[0] == child[0] and item[1] > f_cost):
                        father_node = current_node[0]  
                        border_list.remove(item)
                        border_list.append((child[0], f_cost, father_node))
                        solution_dict[child[0]] = current_node[0]                                          
                        break

            # Add the new g_cost to the distance dictionary
            distance[child[0]] = g_cost
             
        sort_list(border_list)   

# it starts main function
a_star((f"{str(sys.argv[1])}", 0, None))