#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main(){
char op[10];
int num1,num2;

while(scanf("%s %d %d",op,&num1,&num2)==3){
    char libname[20];
    sprintf(libname,"lib%s.so",op);

    void *handle=dlopen(libname,RTLD_LAZY);
    if(!handle){
        fprintf(stderr,"Error loading library\n");
        continue;
    }

    int (*func)(int,int);
    func=(int(*)(int,int)) dlsym(handle,op);

    if(!func){
        fprintf(stderr,"Error finding function\n");
        dlclose(handle);continue;
    }
    int result=func(num1,num2);
    printf("%d\n",result);
    dlclose(handle);
}
return 0;
}