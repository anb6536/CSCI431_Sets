function Find_Sets( fn_in )
%   fn_in = for each card -> [card_num, card_color, shape_count, card_shape, card_texture];
    sets_found = {};
    set_count = 1;
    for card1 = 1:length(fn_in)
        for card2 = card1:length(fn_in)
            for card3 = card2:length(fn_in)
                if card1 ~= card2 && card2 ~= card3 && card1 ~= card3
                    valid_count = 0;
                    if strcmp(fn_in{card1, 2}, fn_in{card2, 2}) && strcmp(fn_in{card2, 2}, fn_in{card3, 2}) ...
                            && strcmp(fn_in{card1, 2}, fn_in{card3, 2})
                        valid_count = valid_count + 1;
                    elseif ~strcmp(fn_in{card1, 2},fn_in{card2, 2}) && ~strcmp(fn_in{card2, 2}, fn_in{card3, 2}) ...
                            && ~strcmp(fn_in{card1, 2},fn_in{card3, 2})
                        valid_count = valid_count + 1;
                    end

                    if fn_in{card1, 3} == fn_in{card2, 3} && fn_in{card2, 3} == fn_in{card3, 3} ...
                            && fn_in{card1, 3} == fn_in{card3, 3}
                        valid_count = valid_count + 1;
                    elseif fn_in{card1, 3} ~= fn_in{card2, 3} && fn_in{card2, 3} ~= fn_in{card3, 3} ...
                            && fn_in{card1, 3} ~= fn_in{card3, 3}
                        valid_count = valid_count + 1;
                    end

                    if fn_in{card1, 4} == fn_in{card2, 4} && fn_in{card2, 4} == fn_in{card3, 4} ...
                            && fn_in{card1, 4} == fn_in{card3, 4}
                        valid_count = valid_count + 1;
                    elseif fn_in{card1, 4} ~= fn_in{card2, 4} && fn_in{card2, 4} ~= fn_in{card3, 4} ...
                            && fn_in{card1, 4} ~= fn_in{card3, 4}
                        valid_count = valid_count + 1;
                    end

                    if fn_in{card1, 5} == fn_in{card2, 5} && fn_in{card2, 5} == fn_in{card3, 5} ...
                            && fn_in{card1, 5} == fn_in{card3, 5}
                        valid_count = valid_count + 1;
                    elseif fn_in{card1, 5} ~= fn_in{card2, 5} && fn_in{card2, 5} ~= fn_in{card3, 5} ...
                            && fn_in{card1, 5} ~= fn_in{card3, 5}
                        valid_count = valid_count + 1;
                    end

                    if valid_count == 4
                        sets_found{set_count, 1} = fn_in{card1, 1};
                        sets_found{set_count, 2} = fn_in{card2, 1};
                        sets_found{set_count, 3} = fn_in{card3, 1};
                        set_count = set_count + 1;
                    end
                end
            end
        end
    end

    fprintf("\nAll Possible Sets in this Image: \n");
    for set_idx = 1:length(sets_found)
        fprintf("Set #%d: Card %d, Card %d, Card %d\n", set_idx, sets_found{set_idx, 1}, sets_found{set_idx, 2}, sets_found{set_idx, 3})
    end
end