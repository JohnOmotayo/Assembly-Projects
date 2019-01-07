extern int MAX_2(int x, int y);

int main() {
		int a, b, c;
		int array[5] = {3, 6, 12, 7, 10};
		int aSize = sizeof(a)/sizeof(a[0]);
		int max = array[0];
		for(int i = 0; i < aSize; i++) {
			a = array[i];
			b = array[i+1];
			if(MAX_(a, b)> max) {
				max = MAX_(a, b);
			}
}
		return max;
}
