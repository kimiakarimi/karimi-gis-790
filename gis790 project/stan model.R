
stanmodelcode = '

data {  
int nl;                          
int nr; 
int nd;                
vector [nr] load;
vector [nr] SD;
int wshed [nr];
int wshed_size;
vector [nr] av_prec;
vector [nr] point;
vector [nr] up_t_load;
vector [nd] d_init;
vector [nl] l_init;
vector [nl] ag;
vector [nl] dev;
vector [nl] wild;
vector [nl] tot_l;
int l_start [nr];
int l_end [nr];
int d_start [nr];
int d_end [nr];
vector [nd] discharger;
vector [nr] ag_lst;
vector [nr] dev_lst; 
vector [nr] wild_lst; 
}

transformed data{


}

parameters {  

real<lower =0> Be_a;        //Agriculture
real<lower =0> Be_d;        //Developed
real<lower =0> Be_w;       //Wild
vector<lower =0, upper = 2> [5] Bp;
real <lower=0> disch;      //Point-Sources
vector [wshed_size] alpha;
real<lower = 0, upper = 2> sigma_B1;
vector [nr] ly;				//log unknown true loads
}

transformed parameters {


}

model {
vector [nr] tot;
vector [nr] sigma;
vector [nr] y_hat;
vector [nr] A;
vector [nr] D;
vector [nr] W;
vector [nr] ch;
vector [nr] h;
vector [nd] disch_mult;
vector [nd] d_vals;
vector [nl] l_vals;
int w;
vector [nr] alpha_vals;
real t;

vector [nr] ly_hat;
vector [nr] y;




A = Be_a*(1+Bp[1]*av_prec) .* ag_lst ;
D = Be_d*(1+Bp[2]*av_prec) .* dev_lst ;
W = Be_w*(1+Bp[3]*av_prec) .* wild_lst ;



for (i in 1:nr){
w= wshed[i];
alpha_vals[i] = alpha[w]*100000;
}



tot =  A + D + W +  disch * (point);
y_hat = tot + alpha_vals;
//priors
Be_a ~ normal(490,130);
Be_d ~ normal(270,110);
Be_w ~ normal(250,85);

alpha ~ normal(0,sigma_w);
sigma_B1 ~ normal(0,2);
Bp ~ normal(0,sigma_B1);
disch ~ normal(.49,.25);

ly_hat=log((y_hat ./ 100000)+10);
ly ~ normal(ly_hat,sigma_res);        

y=exp(ly)-10;

load ~ normal(y,SD);                


}

generated quantities {

}
'