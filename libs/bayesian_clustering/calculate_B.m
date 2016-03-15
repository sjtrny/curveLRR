function B = calculate_B(c,N)

 for row =1:N
        for col = 1:N
            if(c(row)==c(col))
                B(row,col) = 1;
            end;
        end;
 end