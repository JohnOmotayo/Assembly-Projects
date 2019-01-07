#include<stdio.h>

int main() {
		int a[5] = {1, 20, 3, 4, 5};
		int max_val = a[0];
		int aSize = sizeof(a)/sizeof(a[0]);
		int i; 
		for(i = 0; i < aSize; i++) {
			if(max_val < a[i]) { //if max_val is less than the current element in the array
				max_val = a[i];
			}
		}
		return max_val;
}
