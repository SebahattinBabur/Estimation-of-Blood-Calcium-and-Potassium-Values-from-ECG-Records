function [Tamp_mean_TrightSlope_mean,Pamp_mean,Ramp_mean,Tamp_mean,PRinterval_mean,PRsegment_mean,QRScomplex_mean,QTinterval_mean,STsegment_mean,RTduration_mean,TrightSlope_mean,TleftSlope_mean] = ECG_WavefeatureV3(ECGfiltered,FPTLead,Time)
     m=1;
    Pamp=0;Ramp=0;Tamp=0;
    PRinterval=0;PRsegment=0;QRScomplex=0;QTinterval=0;STsegment=0;RTduration=0;
    TrightSlope=0;TleftSlope=0;
    
    for j=1:size( FPTLead,1)-2
            Pindx = FPTLead(j,1:3);
            Qindx = FPTLead(j,4:5);
            Rindx = FPTLead(j,6:7);
            Sindx = FPTLead(j,8:9);
            Tindx = FPTLead(j,10:12);
            
            Pvalue = ECGfiltered(Pindx,1);
            Qvalue = ECGfiltered(Qindx,1);
            Rvalue = ECGfiltered(Rindx,1);
            Svalue = ECGfiltered(Sindx,1);
            Tvalue = ECGfiltered(Tindx,1);
            
            Ptime = Time(Pindx,1);
            Qtime = Time(Qindx,1);
            Rtime = Time(Rindx,1);
            Stime = Time(Sindx,1);
            Ttime = Time(Tindx,1);

            % P,R and T Amplitude
            Pamp_ = Pvalue(2);
            Ramp_ = Rvalue(1);
            Tamp_ = Tvalue(2);
            
            % P, R and T wave Area

            %Angle T Segment
           
            %P,Q,R,S,T Time Value Parameters
            PRinterval_ = Qtime(1)-Ptime(1);
            PRsegment_ = Qtime(1)-Ptime(3);
            QRScomplex_ = Stime(2)-Qtime(1);
            QTinterval_ = Ttime(3) -Qtime(1);
            STsegment_ = Ttime(1) -Stime(2);
            RTduration_ = Ttime(2) -Rtime(1);
            
            %T Wave Slope
            TwaveSlope= diff(Tvalue)./diff(Ttime);
            TleftSlope_ = TwaveSlope(1);
            TrightSlope_ = TwaveSlope(2);
            
            %T center of gravity
            
            Tamp_TrightSlope(j) = Tamp_/TrightSlope_;
            %if TrightSlope_<0 && TleftSlope_>0 && Tamp_>0 && Pamp_>0 && Ramp_>0 && FPTLead(j,14) == 1
                Pamp(m) = Pamp_;
                Ramp(m) = Ramp_;
                Tamp(m) = Tamp_;
                
                PRinterval(m) = PRinterval_;
                PRsegment(m) = PRsegment_;
                QRScomplex(m) = QRScomplex_;
                QTinterval(m) = QTinterval_;
                STsegment(m) = STsegment_;
                RTduration(m)= RTduration_;
                
                TleftSlope(m) = TleftSlope_;
                TrightSlope(m) = TrightSlope_;
                m = m+1;
            %end

    end
    
                Pamp_mean = mean(Pamp);
                Ramp_mean = mean(Ramp);
                Tamp_mean = mean(Tamp);
               
                
                PRinterval_mean = mean(PRinterval);
                PRsegment_mean = mean(PRsegment);
                QRScomplex_mean = mean(QRScomplex);
                QTinterval_mean = mean(QTinterval);
                STsegment_mean = mean(STsegment);
                RTduration_mean = mean(RTduration);
                
                TleftSlope_mean = mean(TleftSlope);
                TrightSlope_mean = mean(TrightSlope);
                
                Tamp_mean_TrightSlope_mean = Tamp_mean/TrightSlope_mean;
                
end
