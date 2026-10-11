function result = crossvalidated_ridge_decoder(activity,labels,folds,penalty)
%CROSSVALIDATED_RIDGE_DECODER Binary held-out ridge least-squares classifier.
% Decoding comparison primitive for Heller et al. and Zhang et al.
% Fold-specific normalization prevents leakage. Fold assignment interleaved.
% Do NOT fit PCA/dDR on the full dataset before held-out decoding.
if nargin<3 || isempty(folds), folds=5; end
if nargin<4 || isempty(penalty), penalty=1; end
x=double(activity); y=double(labels(:));
[n,p]=size(x);
assert(n==numel(y) && all(isfinite(x(:))) && all(isfinite(y)));
classes=unique(y);
assert(numel(classes)==2 && folds>=2 && folds==floor(folds) ...
    && n>=2*folds && penalty>0);
target=ones(n,1); target(y==classes(1))=-1;
pred=nan(n,1); score=nan(n,1);
for k=1:folds
    test=mod((1:n)'-1,folds)+1==k;
    train=~test;
    assert(numel(unique(y(train)))==2,'Train fold has one class');
    mu=mean(x(train,:),1);
    sigma=std(x(train,:),0,1); sigma(sigma==0)=1;
    a=bsxfun(@rdivide,bsxfun(@minus,x(train,:),mu),sigma);
    b=bsxfun(@rdivide,bsxfun(@minus,x(test,:),mu),sigma);
    za=[ones(nnz(train),1) a];
    zb=[ones(nnz(test),1) b];
    regularizer=diag([0;penalty*ones(p,1)]);
    w=(za'*za+regularizer)\(za'*target(train));
    score(test)=zb*w;
end
pred(score>=0)=classes(2);
pred(score<0)=classes(1);
result.prediction=pred;
result.scores=score;
result.accuracy=mean(pred==y);
result.classes=classes;
end
