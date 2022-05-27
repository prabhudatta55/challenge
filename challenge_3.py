#This recursive function will find the value from the key pattern provided
def result(obj,k):
    if k[0] not in obj.keys() or len(k)==1:
        #if there is key reaches at the end return the value from the object
        return obj[k[0]]
    else:
        return result(obj[k[0]],k[1:])

#Sample Input
object_input = {"x":{"y":{"z":"a"}}}
key_input = "x/y/z"

print(result(object_input, key_input.split("/")))