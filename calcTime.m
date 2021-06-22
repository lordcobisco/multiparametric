function [totalTime, totalSec, tOptimizerMult] = calcTime(varargin) 
    if nargin == 1
        load(varargin{1});
    else
        cstart = varargin{1};
        cstop = varargin{2};
    end 
        
    diffMonth = cstop(2) - cstart(2);
    diffDay = cstop(3) - cstart(3);
    diffHour = cstop(4) - cstart(4);
    diffMin = cstop(5) - cstart(5);
    diffSec = cstop(6) - cstart(6);
    
    month = "";
    day = "";
    hour = "";
    min = "";
    sec = "";
    totalSec = 0;
    
    if (diffSec)
        if (diffSec < 0)
            diffSec = 60+diffSec;
            diffMin = diffMin - 1;
        end
        sec = diffSec+"s";
        totalSec = diffSec;
    end
    if (diffMin)
        if (diffMin < 0)
            diffMin = 60+diffMin;
            diffHour = diffHour - 1;
        end
        min = diffMin+"m ";
        totalSec = totalSec+diffMin*60;
    end        
    if (diffHour)
        if (diffHour < 0)
            diffHour = 24+diffHour;
            diffDay = diffDay - 1;
        end        
        hour = diffHour+"h ";
        totalSec = totalSec+diffHour*3600;
    end
    if (diffDay)
        if (diffDay < 0)
            switch(diffMonth)
                case{1,3,5,7,8,10,12}
                    diffDay = 31+diffDay;
                case{4,6,9,11}
                    diffDay = 30+diffDay;
                case{2}
                    diffDay = 28+diffDay;
            end
            diffMonth = diffMonth - 1;
        end 
        day = diffDay+"d ";
        totalSec = totalSec+diffDay*24*3600;
    end
    if (diffMonth)
        month = diffMonth+"M ";        
    end
    
    totalTime = month+day+hour+min+sec;
end
