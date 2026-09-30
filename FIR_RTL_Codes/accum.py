import math
stages = 11 ### Number of FIR Cascaded
max_coeff_sum = 2.71
coeff_bit_size = 32
worst_case = 2.71 ### Max output is equal to max_coeff_sum for 1st filter
### You can tune this worst case to be less pessimistic and also to incorporate offset
sign = 1
integer = 0 ### Initial integer bits
coeff_fraction = 31 ### Number of fraction bits in coefficient
fraction = 31
for i in range(0, stages):
    temp_int = worst_case*(max_coeff_sum**i) ### Maximum output is in powers of worst_case
    temp_int = math.ceil(math.log2(temp_int))
    accumulator = fraction + coeff_fraction*(i > 0) + sign + temp_int
    fraction = coeff_bit_size - sign - temp_int
    print(accumulator)