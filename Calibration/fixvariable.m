%%本函数用来清空无效变量或者空变量.
%%注意并不清空结构体或cell

if exist('var2fix')==1,
    if   eval(['exist(''' var2fix ''') == 1']),
        if eval(['isempty(' var2fix ')']),
            eval(['clear ' var2fix ]);
        else
            if eval(['~isstruct(' var2fix ')']),
                if eval(['~iscell(' var2fix ')']),
                    if eval(['isnan(' var2fix '(1))']),
                        eval(['clear ' var2fix ]);
                    end; 
                end;
            end;
        end;
    end;
end;