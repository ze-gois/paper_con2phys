function [score,detail] = decode_trials(x,y,seed)
    % Five contiguous held-out folds; preprocessing learned on training only.
    % Fixed ridge one-vs-rest model, no tuned hyperparameters.
    keep=all(isfinite(x),2) & isfinite(y); x=x(keep,:); y=y(keep);
    classes=unique(y); n=numel(y); pred=nan(n,1); prob=nan(n,numel(classes));
    score=nan; detail=struct('observed',y,'predicted',pred,'probability',prob);
    if numel(classes)<2 || n<25 || isempty(x), return; end
    fold=min(5,ceil((1:n)'*5/n));
    for f=1:5
        test=fold==f; train=~test;
        if any(arrayfun(@(c)sum(y(train)==c)<2,classes)), continue; end
        mu=mean(x(train,:),1); sd=std(x(train,:),0,1); sd(sd==0)=1;
        a=[ones(sum(train),1) (x(train,:)-mu)./sd];
        b=[ones(sum(test),1) (x(test,:)-mu)./sd];
        target=double(y(train)==classes');
        penalty=eye(size(a,2)); penalty(1,1)=0;
        w=(a'*a+penalty)\(a'*target);
        z=b*w; z=exp(z-max(z,[],2)); z=z./sum(z,2);
        prob(test,:)=z; [~,ii]=max(z,[],2); pred(test)=classes(ii);
    end
    recalls=nan(numel(classes),1);
    for k=1:numel(classes)
        ix=y==classes(k) & isfinite(pred);
        if any(ix), recalls(k)=mean(pred(ix)==y(ix)); end
    end
    if all(isfinite(recalls)), score=mean(recalls); end
    detail=struct('observed',y,'predicted',pred,'probability',prob, ...
        'classes',classes,'fold',fold,'retained_rows',find(keep),'seed',seed);
end
