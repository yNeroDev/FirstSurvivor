class_name WeightedTable
#weighted table used to chose enemies based on their spawn probability
var items: Array[Dictionary] = [] # an array containing a dictionary
var weight_sum = 0

func add_item(item, weight: int):
	items.append({ "item": item, "weight": weight })#	weight_sum += weight #total weight in the Array
	weight_sum += weight

func remove_item(item_to_remove): #give all items in the array that != item_to_remove
	items = items.filter(func (item): return item["item"] != item_to_remove)
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]

func pick_item(exclude: Array = []): #if we dont pass in an exclude array, its empty by default
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item["item"] in exclude: #shorthand for iterating over the exclude array and check if that item is inside there
				continue #stops execution, go to the next item in the loop
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]
			
	
	var chosen_weight = randi_range(1, adjusted_weight_sum) #random number between 1 and total weight
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item["weight"] #goes through the array and picks a weight
		if chosen_weight <= iteration_sum:
			return item["item"] #if the picked weight is less/equal than the random number, func end
