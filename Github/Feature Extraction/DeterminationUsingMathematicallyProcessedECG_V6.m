clear;clc;
addpath(genpath('.')); % add current directory
load('C:\Users\Sebahattin BABUR\Desktop\Non-invasive Determination Using a Mathematically Processed ECG\QRS_Signal_New\Match_Calcium_Waveforms_Name_p09_562_1hour_II_PLETH_QRS_Signal.mat')
load('C:\Users\Sebahattin BABUR\Desktop\Non-invasive Determination Using a Mathematically Processed ECG\Dataset\Match_Calcium_Waveforms_Name_p09_562_1hour_II_PLETH.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fidi = fopen('./PATIENTS/PATIENTS.csv','r');
dosyayeri='PATIENTS/';
L = fgets(fidi);
k1 = 0;
while ~(feof(fidi))
    k1 = k1 + 1;
    L = fgetl(fidi);
    fields = length(regexp(L, ','))+1;
    Data{k1} = textscan(L, repmat('%s', 1, fields), 'Delimiter',',');
end

for i=1:size(mimiciii_signals,2)
    temp1 = mimiciii_signals(1,i).data(4);
    subject_id_signal = str2double(temp1{1});
    for j=1:size(Data,2)
        temp2=Data{1,j};
        subject_id_patient = str2double(temp2{2});

        if subject_id_signal == subject_id_patient

            %Gender detect
           gender_temp = char(temp2{3});
           gender = gender_temp(2);
            if gender == 'F'
            mimiciii_signals(1,i).gender = 1; %Female = 1
            end
            if gender == 'M'
            mimiciii_signals(1,i).gender = 2; %Male = 2
            end

            %Age Detect
            temp3 = mimiciii_signals(1,i).data(6);
            age_temp1 = char(temp3{1});
            Age1 = str2double(age_temp1(1:4));

            age_temp2 = char(temp2{4});
            Age2 = str2double(age_temp2(1:4));
            Age= Age1-Age2;
            if Age <= 20
                mimiciii_signals(1,i).age =1;
            elseif Age >=21&& Age <=40
                mimiciii_signals(1,i).age =2;
            elseif Age >=41&& Age <=60
                mimiciii_signals(1,i).age =3;
            elseif Age >=61
                mimiciii_signals(1,i).age =4;  
                end              
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mu = 0;
k = 1;
for i=1:size(QRS_signals,2)
        %i
        ecgsignals = QRS_signals(1,i);
        ECGfiltered = ecgsignals.ecg_filtered_isoline;
        
        Fs = 250;% Sampling Frequency (Hz)
        FPTLead = ecgsignals.FPT_LeadII;
        
        temp = mimiciii_signals(i).data(2);
        signaldate= cell2mat(temp{1});
        signalhour = str2num(signaldate(32:33))*60*60+str2num(signaldate(35:36))*60;
        
        temp = mimiciii_signals(i).data(6);
        Labdate= cell2mat(temp{1});
        Labhour = str2num(Labdate(12:13))*60*60+str2num(Labdate(15:16))*60;
        
        Time = linspace(0, numel(ECGfiltered), numel(ECGfiltered))'/Fs;

        timesize  = Labhour - signalhour;
        TimeIndex1 = Time(:,1)>timesize-2;%2sn
        TimeIndex2 = Time(:,1)<timesize+2;%2sn
        TimeIndex = TimeIndex1.*TimeIndex2;
        
        TimeIndx = find(TimeIndex(:,1)== 1);
        
        if timesize >=0 && timesize<=3600 && size(TimeIndx,1)>0 && ~isequaln(FPTLead ,[]) && ~isequaln(QRS_signals(i).ICD9_CODE,[]) 
                        for j=1:size(FPTLead,1)
                            if FPTLead(j,1)>=TimeIndx(1)&& FPTLead(j,1)<=TimeIndx(size(TimeIndx,1))
                               FPTLead(j,14) =1;
                               
                            else
                               FPTLead(j,14) =0;
                            end
                        end
               
                %% Smooth input data
                Data_ECG = smoothdata(ECGfiltered,"movmean","SmoothingFactor",0.25);
                %% Normalize Data
                Data_ECG = normalize(Data_ECG);

                [Tamp_mean_TrightSlope_mean,Pamp_mean,Ramp_mean,Tamp_mean,PRinterval_mean,PRsegment_mean,QRScomplex_mean,QTinterval_mean,STsegment_mean,RTduration_mean,TrightSlope_mean,TleftSlope_mean] = ECG_WavefeatureV3(Data_ECG,FPTLead,Time);
                Morf_features(i,1) = Pamp_mean;
                Morf_features(i,2) = Ramp_mean;
                Morf_features(i,3) = Tamp_mean;
                
                Morf_features(i,4) = PRinterval_mean;
                Morf_features(i,5) = PRsegment_mean; 
                Morf_features(i,6) = QRScomplex_mean;
                Morf_features(i,7) = QTinterval_mean;
                Morf_features(i,8) = STsegment_mean;
                Morf_features(i,9) = RTduration_mean;
        
                Morf_features(i,10) = TrightSlope_mean;
                Morf_features(i,11) = TleftSlope_mean;
                
                Morf_features(i,12) = Tamp_mean_TrightSlope_mean;
                
                signal = ECGfiltered(TimeIndx,1);
                %% Smooth input data
                signal = smoothdata(signal,"movmean","SmoothingFactor",0.25);
                %% Normalize Data
                signal = normalize(signal);
                T   = 0.004   ;         %4 milliseconds between successive observation T =1/Fs
                N   = 1000     ;         % 4s 
                
                % if length(TimeIndx) == N    
                %     [feature(i,:)] = ECG_Frequency_Feature(ECGsignal,Fs,N)';
                % end
                
                Flagtemp = mimiciii_signals(i).data(9);
                if string(Flagtemp{1}) == "abnormal"
                    QRS_signals(i).Flag = 1; %abnormal = 1
                else
                    QRS_signals(i).Flag = 0; %normal = 0
                end
                Flag= Data_Cleaner_Function(ECGfiltered(TimeIndx,1));         
                if size(signal,1) == N && Flag == true
                    
                    mu = mu+1;
                    [ECG_Morfological_Features(mu,:)] = Morf_features(i,:) ;
                    [ECG_Data(mu,:)] = signal;
                    [ECG_Age(mu,:)] = mimiciii_signals(1,i).age;
                    [ECG_Data_Label(mu,1)] = QRS_signals(i).Flag;
                    [ECG_Data_Value(mu,1)] = QRS_signals(i).Calcium;
                    [ECG_Data_ICD9(mu,1)] = QRS_signals(i).ICD9_CODE;
                end
        
        end

end
save('New_Features2/Match_Calcium_Waveforms_Name_V2_p09_562_1hour_II_PLETH_QRS_Signal_ECGData_4s.mat','ECG_Age','ECG_Data','ECG_Data_Label','ECG_Data_Value','ECG_Data_ICD9','ECG_Morfological_Features');