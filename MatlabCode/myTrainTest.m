function [trainRr, testRr]=myTrainTest(ds4train, ds4test, classifier)
    if strcmp(classifier, 'nbc')
        [cPrm, logLike1, recogRate1]=nbcTrain(ds4train);
        [computedClass, logLike2, recogRate2, hitIndex]=nbcEval(ds4test, cPrm);
    elseif strcmp(classifier, 'qc')
        [cPrm, logLike1, recogRate1]=qcTrain(ds4train);
        [computedClass, logLike2, recogRate2, hitIndex]=qcEval(ds4test, cPrm);
    end
    trainRr = recogRate1;
    testRr = recogRate2;
end