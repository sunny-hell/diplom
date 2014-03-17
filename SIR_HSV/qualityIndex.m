function [qIndex] = qualityIndex(P,Q)
    % P, Q - ground truth and estimated bounding boxes of target
    sPQ = rectint(P,Q);
    sP = P(3)*P(4);
    sQ = Q(3)*Q(4);
    qIndex = sPQ/max(sP, sQ);
end
