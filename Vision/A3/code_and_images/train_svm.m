run('C:/dev/vlfeat-0.9.20/toolbox/vl_setup');
load('training_feats.mat')

feats = cat(1, pos_train_feats,neg_train_feats);
labels = cat(1, ones(pos_nImages,1),-1*ones(neg_nImages,1));

lambda = 0.1;
[w,b] = vl_svmtrain(feats',labels',lambda);

fprintf('Classifier performance on train data:\n')
confidences = [pos_train_feats; neg_train_feats]*w + b;

[tp_rate, fp_rate, tn_rate, fn_rate] =  report_accuracy(confidences, labels);

save('svm.mat','w','b');
