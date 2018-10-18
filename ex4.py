
# coding: utf-8

# 0. When I wrote this program the first time I had a mistake, and Python told me about it like this:
# 
# Traceback (most recent call last):
#   File "ex4.py", line 8, in <module>
#     average_passengers_per_car = car_pool_capacity / passenger
# NameError: name 'car_pool_capacity' is not defined
# Explain this error in your own words. Make sure you use line numbers and explain why.
# 
# Here are more study drills:
# 
# 1. I used 4.0 for space_in_a_car, but is that necessary? What happens if it's just 4?
# 2. Remember that 4.0 is a floating point number. It's just a number with a decimal point, and you need 4.0 instead of just 4 so that it is floating point.
# 3. Write comments above each of the variable assignments.
# 4. Make sure you know what = is called (equals) and that its purpose is to give data (numbers, strings, etc.) names (cars_driven, passengers).
# 5. Remember that _ is an underscore character.
# 6. Try running python3.6 from the Terminal as a calculator like you did before, and use variable names to do your calculations. Popular variable names are also i, x, and j.

# In[4]:


cars = 100
space_in_a_car = 4.0
drivers = 30
passengers = 90
cars_not_driven = cars - drivers
cars_driven = drivers
carpool_capacity = cars_driven * space_in_a_car
average_passengers_per_car = passengers / cars_driven


print("There are", cars, "cars available.")
print("There are only", drivers, "drivers available.")
print("There will be", cars_not_driven, "empty cars today.")
print("We can transport", carpool_capacity, "people today.")
print("We have", passengers, "to carpool today.")
print("We need to put about", average_passengers_per_car,
      "in each car.")


# In[5]:


# 0
# It is because the author forgot to type "carpool_capacity = cars_driven * space_in_a_car" (without "") in line 7, or did not 
# spell "carpool_capacity" (without "") correctly, which cause "carpool_capacity" undefined


# In[6]:


# 1
# No. Let's see what happens if we change "space_in_a_car = 4.0" to "space_in_a_car = 4" (without "")

cars = 100
space_in_a_car = 4
drivers = 30
passengers = 90
cars_not_driven = cars - drivers
cars_driven = drivers
carpool_capacity = cars_driven * space_in_a_car
average_passengers_per_car = passengers / cars_driven


print("There are", cars, "cars available.")
print("There are only", drivers, "drivers available.")
print("There will be", cars_not_driven, "empty cars today.")
print("We can transport", carpool_capacity, "people today.")
print("We have", passengers, "to carpool today.")
print("We need to put about", average_passengers_per_car,
      "in each car.")


# In[7]:


# 2
# it not necessary now because it will be automatically transfered into a floating point number.cars = 100


# In[8]:


# 3

# just the space in a car
space_in_a_car = 4.0

# total number of drivers
drivers = 30

# total number of passengers
passengers = 90

# cars not driven because there are not enough drivers
cars_not_driven = cars - drivers

# cars which are driven because each driver drives a car
cars_driven = drivers

# the total capacity of the carpool if all cars are full
carpool_capacity = cars_driven * space_in_a_car

# average passengers per car for the given numbers of passengers, cars and drivers
average_passengers_per_car = passengers / cars_driven


# In[9]:


# 4
# operator '=' is used to assign values to the variables


# In[10]:


# 5
# character '_' is only a normal character that can be used in the name of a variable 


# In[11]:


# 6
# some simple cases:
i = 1
j = 4 
x = 3
(i + j) / x

