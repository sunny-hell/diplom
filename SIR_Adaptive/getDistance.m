function D = getDistance(q_templ, q)
    D = 1.0-sum(sqrt(q_templ(:).*q(:)));
end
