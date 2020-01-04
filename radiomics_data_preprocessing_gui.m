function varargout = radiomics_data_preprocessing_gui(varargin)
% RADIOMICS_DATA_PREPROCESSING_GUI MATLAB code for radiomics_data_preprocessing_gui.fig
%      RADIOMICS_DATA_PREPROCESSING_GUI, by itself, creates a new RADIOMICS_DATA_PREPROCESSING_GUI or raises the existing
%      singleton*.
%
%      H = RADIOMICS_DATA_PREPROCESSING_GUI returns the handle to a new RADIOMICS_DATA_PREPROCESSING_GUI or the handle to
%      the existing singleton*.
%
%      RADIOMICS_DATA_PREPROCESSING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RADIOMICS_DATA_PREPROCESSING_GUI.M with the given input arguments.
%
%      RADIOMICS_DATA_PREPROCESSING_GUI('Property','Value',...) creates a new RADIOMICS_DATA_PREPROCESSING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before radiomics_data_preprocessing_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to radiomics_data_preprocessing_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help radiomics_data_preprocessing_gui

% Last Modified by GUIDE v2.5 20-Apr-2019 23:03:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @radiomics_data_preprocessing_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @radiomics_data_preprocessing_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before radiomics_data_preprocessing_gui is made visible.
end


function radiomics_data_preprocessing_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to radiomics_data_preprocessing_gui (see VARARGIN)

% Choose default command line output for radiomics_data_preprocessing_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes radiomics_data_preprocessing_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% set(handles.data_output_Callback,'Enable',off);
% set(handles.Running_Callback,'Enable',off);

end


% --- Outputs from this function are returned to the command line.
function varargout = radiomics_data_preprocessing_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in click.
function click_Callback(hObject, eventdata, handles)
% hObject    handle to click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str_message = ({'Warning:Data_Input button should include data and label folders that contain sub-folders by patients.';
    'The contents in Data and label folders should correspond one-to-one！'; 'Pay Attention:Windows center&width should be set in 16bits dcm files!';
    'Deafault Mode: 16bit dcm files & manual ROIs';'';'If there are any mistakes stopping the program, please check your input_folders and clean your output_folder then retry it!'});
h = msgbox(str_message,'Warning'); 

end


% --- Executes on button press in data_input.
function data_input_Callback(hObject, eventdata, handles)
% hObject    handle to data_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%获取文件夹
datainput_folder = uigetdir;

handles.datainput_folder = datainput_folder;
guidata(hObject,handles);  %更新handles里面每一个元素

set(handles.data_output,'Enable','on');

end


% --- Executes on button press in data_output.
function data_output_Callback(hObject, eventdata, handles)
% hObject    handle to data_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%获取文件夹
dataoutput_folder = uigetdir;

handles.dataoutput_folder = dataoutput_folder;
guidata(hObject,handles);

set(handles.Running,'Enable','on');

end


% --- Executes on button press in Running.
function Running_Callback(hObject, eventdata, handles)
% hObject    handle to Running (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 初始参量传递
datainput_folder=handles.datainput_folder;
dataoutput_folder=handles.dataoutput_folder;

% 文件类型
% % data_type = cellstr(get(handles.data_type,'String'));
% data_type = get(handles.data_type,'String');
% % label_type = cellstr(get(handles.label_type,'String'));
% label_type = get(handles.label_type,'String');

data_type = cellstr(get(handles.data_type,'String'));
% data_type{get(handles.data_type,'Value')};

label_type = cellstr(get(handles.label_type,'String'));
% label_type{get(handles.label_type,'Value')};



%----------------------------------------------------------------------------------------------------------------------------------------------------%
% 8bit dcm和 8bit 手动label的存储
%----------------------------------------------------------------------------------------------------------------------------------------------------%

if ((get(handles.Auto_label,'value')== 0) && (get(handles.dcmbit,'value')== 1))

    % 目录集合
    str_origin_data = (strcat(datainput_folder,'\data\'));
    str_origin_label = (strcat(datainput_folder,'\label\'));
    str_target_bmp = (strcat(dataoutput_folder,'\bmp\'));
    str_target_dcm = (strcat(dataoutput_folder,'\dcm\'));


    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % label文件的bmp存储和dcm存储
    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % 建立文件夹
    mkdir(strcat(dataoutput_folder,'\bmp'));
    mkdir(strcat(dataoutput_folder,'\dcm'));
    mkdir(strcat(str_target_bmp,'label_bmp')); %存储label二值图片
    mkdir(strcat(str_target_dcm,'label_dcm')); %存储label二值图片



%     %进度条
%     str = ({'请稍等正在识别label文件夹内ROI...';'若进度条无反应请关闭程序并打开主页面说明！'});
%     h0 = waitbar(0,str);
%     pause(2);
    
    %进度条
    str = ({'Please waiting to scan the ROIs in label folders...';'Please restart it if the bar does not move for a long time！'});
    h0 = waitbar(0,str);
    pause(2);



    p = genpath(str_origin_label);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path = {}; 
    temp = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp = [temp p(i)];
        else 
            %temp = [temp ':' '\']; 
            path = [temp '\' ; path]; % 加一个斜杠换到下一行
            temp = [];
        end
    end  

    d = dir(str_origin_label); 
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
    num = length(nameFolds);


    for i=1:(length(path)-1)
        dirOutput=dir(fullfile(path{i},(strcat('*.',label_type{get(handles.label_type,'Value')})))); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
        fileNames={dirOutput.name}'; % 列向量
        mkdir(strcat(str_target_bmp,'label_bmp\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）
        mkdir(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）
        
        %进度条
%         str0=['第',num2str(i),'个文件夹图片转化中...'];
        str0=['Reading the num ', num2str(i), 'folder in label folders...'];
        h1 = waitbar(0,str0);
        
        for p=1:length(fileNames)
            I=imread(strcat(path{i},fileNames{p}));

            %二值转化
            Ir=I(:,:,1)*2-I(:,:,2)-I(:,:,3);  
            Ir=medfilt2(Ir,[2,2]);
            img=255-Ir;
            img_temp = img<150; % 改变边缘粗细（其他数据的值为150，太细的值为140，太粗的值不一定，但是在PS里要用1像素红色画笔去画）

            % find the number of white circle
            [~, numWhite] = bwlabel(img_temp);

            % 存储阈值最大时roi的原始数量
            ori_numWhite = numWhite;



            % 单个roi的标注
            if ori_numWhite == 1

                for b_threshold = 150:10:230
                    img_temp = img<b_threshold;
                    img_temp=imfill(img_temp,'holes');
                    [~, L] = bwboundaries(img_temp,'holes');
                    numAll = max(L(:));

                    if(numAll == ori_numWhite)
                        break;
                    end    
                end

                img = img<b_threshold+20;
                img_bmp=imfill(img,'holes');
    %             img_dcm = rgb2gray(img_bmp); % RGB-Gray8            
                fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀

                % 写入文件
                imwrite(img_bmp, strcat(strcat(str_target_bmp,'label_bmp\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.bmp')));
                dicomwrite(img_bmp, strcat(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')));

            end


            % 多个roi的标注
            if ori_numWhite ~= 1

                for b_threshold = 120:10:220
                    img_temp = img<b_threshold;
                    [~, L] = bwboundaries(img_temp,'holes');
                    numAll = max(L(:));

                    img_temp1=imfill(img_temp,'holes');
                    [~, L] = bwboundaries(img_temp1,'holes');
                    numAll_temp = max(L(:));

                    if(numAll == ori_numWhite*2) && (numAll_temp == 1)
                        break;
                    end    
                end

                img_bmp = img<b_threshold;


                % 判断填充方式
                img_bmp_temp=imfill(img_bmp,'holes');
                [~, L] = bwboundaries(img_bmp_temp,'holes');
                numAll = max(L(:));

                % 独立roi填充
                if(numAll == ori_numWhite)               
                    img_bmp=imfill(img_bmp,'holes');
                else        
                    % 圆环填充
                    % find all objects with holes
                    [~, L] = bwboundaries(img_bmp,'holes');
                    numAll = max(L(:));
                    % fill the first hole to last second hole
                    for x=1:numWhite+1
                        img_bmp(L==x) = 1;
                    end
                end

                fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀     

                % 写入文件
                imwrite(img_bmp, strcat(strcat(str_target_bmp,'label_bmp\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.bmp')));
                dicomwrite(img_bmp, strcat(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')));

            end

%             % 进度条
%             str1=['正在识别第',num2str(i),'个label文件夹中的第',num2str(p),'张图片']; 
%             waitbar(p/(length(fileNames)),h1,str1);
            
            % 进度条
            str1=['Gotten the ROIs by ',num2str(p),'images in ',num2str(i), 'label folders...' ]; 
            waitbar(p/(length(fileNames)),h1,str1);

        end 

%         % 进度条
%         str2=['label的第',num2str(i),'个文件夹图片已识别完成'];
%         waitbar(1,h1,str2);
%         pause(1);
%         delete(h1);
% 
%         waitbar(i/(length(path)-1),h0,'正在读取下一个文件夹图片...');
%         pause(1)
        
        % 进度条
        str2=['Finish the ',num2str(i), 'label folder!'];
        waitbar(1,h1,str2);
        pause(1);
        delete(h1);

        waitbar(i/(length(path)-1),h0,'Reading the next label folder...');
        pause(1)

    end
%     waitbar(1,h0,'所有label文件识别已完成');
    waitbar(1,h0,'Finish all label folders!');
    pause(1);
    delete(h0);



    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % data文件的dcm存储
    %----------------------------------------------------------------------------------------------------------------------------------------------------%

    % 建立文件夹
    mkdir(strcat(str_target_dcm,'data_dcm')); %存储label二值图片

    %进度条
%     str = ({'请稍等正在读取data文件夹内容...';'若进度条无反应请关闭程序并打开主页面说明！'});
    str = ({'Please waiting to scan the images in data folders...';'Please restart it if the bar does not move for a long time！'});
    h0 = waitbar(0,str);
    pause(2);


    p = genpath(str_origin_data);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path = {}; 
    temp = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp = [temp p(i)];
        else 
            %temp = [temp ':' '\']; 
            path = [temp '\' ; path]; % 加一个斜杠换到下一行
            temp = [];
        end
    end  

    d = dir(str_origin_data); 
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
    num = length(nameFolds);
    
    
    for i=1:(length(path)-1)
        dirOutput=dir(fullfile(path{i},(strcat('*.',data_type{get(handles.data_type,'Value')})))); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
        fileNames={dirOutput.name}'; % 列向量
        mkdir(strcat(str_target_dcm,'data_dcm\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）

        %进度条
        str0=['Reading the num ', num2str(i), 'folder in data folders...'];
        h1 = waitbar(0,str0);
        
        for p=1:length(fileNames)
            I=imread(strcat(path{i},fileNames{p}));

            img = rgb2gray(I); % RGB-Gray8

            % 将bmp文件转为可用的灰度dcm文件
            fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀     
            dicomwrite(img, strcat(strcat(str_target_dcm,'data_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')));

            % 进度条
%             str1=['正在转换第',num2str(i),'个data文件夹中的第',num2str(p),'张图片']; 
%             waitbar(p/(length(fileNames)),h1,str1);
            
            str1=['Gotten the ROIs by ',num2str(p),'images in ',num2str(i), 'label folders...' ]; 
            waitbar(p/(length(fileNames)),h1,str1);

        end

%         % 进度条
%         str2=['data文件夹的第',num2str(i),'个文件夹图片已转换完成'];
%         waitbar(1,h1,str2);
%         pause(1);
%         delete(h1);
% 
%         waitbar(i/(length(path)-1),h0,'正在读取下一个文件夹图片...');
%         pause(1)

        % 进度条
        str2=['Finish the ',num2str(i), 'data folder!'];
        waitbar(1,h1,str2);
        pause(1);
        delete(h1);

        waitbar(i/(length(path)-1),h0,'Reading the next data folder...');
        pause(1)

    end

    % 进度条
%     waitbar(1,h0,'所有data文件夹内容转换已完成');
    waitbar(1,h0,'Finish all data folders!');
    pause(1);
    delete(h0);

end















%----------------------------------------------------------------------------------------------------------------------------------------------------%
% 16bit dcm和 8bit手动label的存储
%----------------------------------------------------------------------------------------------------------------------------------------------------%

if ((get(handles.Auto_label,'value')== 0) && (get(handles.dcmbit,'value')== 0))
    
    % 目录集合
    str_origin_data = (strcat(datainput_folder,'\data\'));
    str_origin_label = (strcat(datainput_folder,'\label\'));
    str_target_bmp = (strcat(dataoutput_folder,'\bmp\'));
    str_target_dcm = (strcat(dataoutput_folder,'\dcm\'));


    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % label文件的bmp存储和dcm存储
    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % 建立文件夹
    mkdir(strcat(dataoutput_folder,'\bmp'));
    mkdir(strcat(dataoutput_folder,'\dcm'));
    mkdir(strcat(str_target_bmp,'label_bmp')); %存储label二值图片
    mkdir(strcat(str_target_dcm,'label_dcm')); %存储label二值图片



    %进度条
    str = ({'Please waiting to scan the images in label folders...';'Please restart it if the bar does not move for a long time！'});
    h0 = waitbar(0,str);
    pause(2);


    p = genpath(str_origin_label);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path = {}; 
    temp = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp = [temp p(i)];
        else 
            %temp = [temp ':' '\']; 
            path = [temp '\' ; path]; % 加一个斜杠换到下一行
            temp = [];
        end
    end  

    d = dir(str_origin_label); 
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
    num = length(nameFolds);


    for i=1:(length(path)-1)
        dirOutput=dir(fullfile(path{i},(strcat('*.',label_type{get(handles.label_type,'Value')})))); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
        fileNames={dirOutput.name}'; % 列向量
        mkdir(strcat(str_target_bmp,'label_bmp\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）
        mkdir(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）
        
        %进度条
        str0=['Reading the num ', num2str(i), 'folder in label folders...'];
        h1 = waitbar(0,str0);
        

        for p=1:length(fileNames)
            I=imread(strcat(path{i},fileNames{p}));

            %二值转化
            a=I(:,:,2);
            b=I(:,:,1);
            c=I(:,:,3);
            Ir=I(:,:,1)*2-I(:,:,2)-I(:,:,3);  
            Ir=medfilt2(Ir,[2,2]);
            img=255-Ir;
            img_temp = img<150; % 改变边缘粗细（其他数据的值为150，太细的值为140，太粗的值不一定，但是在PS里要用1像素红色画笔去画）

            % find the number of white circle
            [~, numWhite] = bwlabel(img_temp);

            % 存储阈值最大时roi的原始数量
            ori_numWhite = numWhite;



            % 单个roi的标注
            if ori_numWhite == 1

                for b_threshold = 150:10:240
                    img_temp = img<b_threshold;
                    img_temp=imfill(img_temp,'holes');
                    [~, L] = bwboundaries(img_temp,'holes');
                    numAll = max(L(:));

                    if(numAll == ori_numWhite)
                        break;
                    end    
                end

                img = img<b_threshold+20;
                img_bmp=imfill(img,'holes');
    %             img_dcm = rgb2gray(img_bmp); % RGB-Gray8            
                fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀

                % 写入文件
                imwrite(img_bmp, strcat(strcat(str_target_bmp,'label_bmp\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.bmp')));
                dicomwrite(img_bmp, strcat(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')));

            end


            % 多个roi的标注
            if ori_numWhite ~= 1

                for b_threshold = 120:10:220
                    img_temp = img<b_threshold;
                    [~, L] = bwboundaries(img_temp,'holes');
                    numAll = max(L(:));

                    img_temp1=imfill(img_temp,'holes');
                    [~, L] = bwboundaries(img_temp1,'holes');
                    numAll_temp = max(L(:));

                    if(numAll == ori_numWhite*2) && (numAll_temp == 1)
                        break;
                    end    
                end

                img_bmp = img<b_threshold;


                % 判断填充方式
                img_bmp_temp=imfill(img_bmp,'holes');
                [~, L] = bwboundaries(img_bmp_temp,'holes');
                numAll = max(L(:));

                % 独立roi填充
                if(numAll == ori_numWhite)               
                    img_bmp=imfill(img_bmp,'holes');
                else        
                    % 圆环填充
                    % find all objects with holes
                    [~, L] = bwboundaries(img_bmp,'holes');
                    numAll = max(L(:));
                    % fill the first hole to last second hole
                    for x=1:numWhite+1
                        img_bmp(L==x) = 1;
                    end
                end

                fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀     

                % 写入文件
                imwrite(img_bmp, strcat(strcat(str_target_bmp,'label_bmp\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.bmp')));
                dicomwrite(img_bmp, strcat(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')));

            end

            % 进度条
%             str1=['正在转换第',num2str(i),'个data文件夹中的第',num2str(p),'张图片']; 
%             waitbar(p/(length(fileNames)),h1,str1);
            
            str1=['Gotten the ROIs by ',num2str(p),'images in ',num2str(i), 'label folders...' ]; 
            waitbar(p/(length(fileNames)),h1,str1);

        end 

        % 进度条
        str2=['Finish the ',num2str(i), 'label folder!'];
        waitbar(1,h1,str2);
        pause(1);
        delete(h1);

        waitbar(i/(length(path)-1),h0,'Reading the next label folder...');
        pause(1)

    end
    
    %进度条
    waitbar(1,h0,'Finish all label folders!');
    pause(1);
    delete(h0);
    
    
    
    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % data文件的dcm存储
    %----------------------------------------------------------------------------------------------------------------------------------------------------%

    % 建立文件夹
    mkdir(strcat(str_target_dcm,'data_dcm')); %存储label二值图片

    %进度条
%     str = ({'请稍等正在读取data文件夹内容...';'若进度条无反应请关闭程序并打开主页面说明！'});
    str = ({'Please waiting to scan the images in data folders...';'Please restart it if the bar does not move for a long time！'});
    h0 = waitbar(0,str);
    pause(2);


    p = genpath(str_origin_data);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path = {}; 
    temp = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp = [temp p(i)];
        else 
            %temp = [temp ':' '\']; 
            path = [temp '\' ; path]; % 加一个斜杠换到下一行
            temp = [];
        end
    end  

    d = dir(str_origin_data); 
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
    num = length(nameFolds);


    for i=1:(length(path)-1)
        dirOutput=dir(fullfile(path{i},'*.dcm')); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
        fileNames={dirOutput.name}'; % 列向量
        mkdir(strcat(str_target_dcm,'data_dcm\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）

        %进度条
        str0=['Reading the num ', num2str(i), 'folder in data folders...'];
        h1 = waitbar(0,str0);
        
        for p=1:length(fileNames)
            DCM =dicominfo(strcat(path{i},fileNames{p}));
            I_data=dicomread(DCM);
            
            % 数据清洗
            DCM.InstitutionName=''; 
            DCM.InstitutionAddress=''; 
            DCM.PatientName='';
            DCM.PatientID='';
            
            % 窗宽窗位
            if (get(handles.centerwidth,'value')== 1)
                
                %提取窗宽窗位信息
                window_center=get(handles.center,'String');
                window_width=get(handles.width,'String');
                DCM.WindowCenter = str2double(window_center);
                DCM.WindowWidth = str2double(window_width);

            end
            
            % 数据处理
            DCM.ImagePositionPatient = [0,0,0];
            DCM.PixelSpacing = [0,0];
            

            % 将bmp文件转为可用的灰度dcm文件
            fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀     
            dicomwrite(I_data, strcat(strcat(str_target_dcm,'data_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')), DCM);

            % 进度条
            str1=['Gotten image num ',num2str(p),' in ',num2str(i), 'data folders...' ]; 
            waitbar(p/(length(fileNames)),h1,str1);

        end

        % 进度条
        str2=['Finish num ',num2str(i), 'data folder!'];
        waitbar(1,h1,str2);
        pause(1);
        delete(h1);

        waitbar(i/(length(path)-1),h0,'Reading the next data folder...');
        pause(1)

    end

    %进度条
    waitbar(1,h0,'Finish all data folders!');
    pause(1);
    delete(h0);
     
    
end
















%----------------------------------------------------------------------------------------------------------------------------------------------------%
% 16bit dcm和 8bit自动分割的label的存储
%----------------------------------------------------------------------------------------------------------------------------------------------------%


if((get(handles.Auto_label,'value')== 1) && (get(handles.dcmbit,'value')== 0))
    
    
    % 目录集合
    str_origin_data = (strcat(datainput_folder,'\data\'));
    str_origin_label = (strcat(datainput_folder,'\label\'));
    str_target_dcm = (strcat(dataoutput_folder,'\dcm\'));


    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % label文件的dcm存储
    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % 建立文件夹
    mkdir(strcat(dataoutput_folder,'\dcm'));
    mkdir(strcat(str_target_dcm,'label_dcm')); %存储label二值图片


    %进度条
    str = ({'Please waiting to scan the images in label folders...';'Please restart it if the bar does not move for a long time！'});
    h0 = waitbar(0,str);
    pause(2);


    p = genpath(str_origin_label);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path = {}; 
    temp = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp = [temp p(i)];
        else 
            %temp = [temp ':' '\']; 
            path = [temp '\' ; path]; % 加一个斜杠换到下一行
            temp = [];
        end
    end  

    d = dir(str_origin_label); 
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
    num = length(nameFolds);
    
    for i=1:(length(path)-1)
        dirOutput=dir(fullfile(path{i},(strcat('*.',label_type{get(handles.label_type,'Value')}))));
        fileNames={dirOutput.name}'; % 列向量
        mkdir(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）

        %进度条
        str0=['Reading the num ', num2str(i), 'folder in label folders...'];
        h1 = waitbar(0,str0);
        
        for p=1:length(fileNames)
            I=imread(strcat(path{i},fileNames{p}));
            
            % 写入文件
            fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀 
            dicomwrite(I, strcat(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')));
            
            %进度条
            str1=['Gotten the ROIs by ',num2str(p),'images in ',num2str(i), 'label folders...' ]; 
            waitbar(p/(length(fileNames)),h1,str1);
        end
        
        % 进度条
        str2=['Finish num ',num2str(i), 'label folder!'];
        waitbar(1,h1,str2);
        pause(1);
        delete(h1);

        waitbar(i/(length(path)-1),h0,'Reading the next label folder...');
        pause(1)


    end 
    waitbar(1,h0,'Finish all label folders!');
    pause(1);
    delete(h0);

    
    
    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % data文件的dcm存储
    %----------------------------------------------------------------------------------------------------------------------------------------------------%

    % 建立文件夹
    mkdir(strcat(str_target_dcm,'data_dcm'));

    %进度条
    str = ({'Please waiting to scan the images in data folders...';'Please restart it if the bar does not move for a long time！'});
    h0 = waitbar(0,str);
    pause(2);


    p = genpath(str_origin_data);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path = {}; 
    temp = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp = [temp p(i)];
        else 
            %temp = [temp ':' '\']; 
            path = [temp '\' ; path]; % 加一个斜杠换到下一行
            temp = [];
        end
    end  

    d = dir(str_origin_data); 
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
    num = length(nameFolds);


    for i=1:(length(path)-1)
        dirOutput=dir(fullfile(path{i},'*.dcm')); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
        fileNames={dirOutput.name}'; % 列向量
        mkdir(strcat(str_target_dcm,'data_dcm\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）

        %进度条
        str0=['Reading the num ', num2str(i), 'folder in data folders...'];
        h1 = waitbar(0,str0);
        
        for p=1:length(fileNames)
            DCM =dicominfo(strcat(path{i},fileNames{p}));
            I_data=dicomread(DCM);
            
            % 数据清洗
            DCM.InstitutionName=''; 
            DCM.InstitutionAddress=''; 
            DCM.PatientName='';
            DCM.PatientID='';
            
            % 数据处理
            DCM.ImagePositionPatient = [0,0,0];
            DCM.PixelSpacing = [0,0];
            
            % 窗宽窗位
            if (get(handles.centerwidth,'value')== 1)
                
                %提取窗宽窗位信息
                window_center=get(handles.center,'String');
                window_width=get(handles.width,'String');
                DCM.WindowCenter = str2double(window_center);
                DCM.WindowWidth = str2double(window_width);

            end
            

            % 将bmp文件转为可用的灰度dcm文件
            fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀     
            dicomwrite(I_data, strcat(strcat(str_target_dcm,'data_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')), DCM);

            % 进度条
            str1=['Gotten image num ',num2str(p),' in ',num2str(i), 'data folders...' ]; 
            waitbar(p/(length(fileNames)),h1,str1);

        end

        % 进度条
        str2=['Finish num ',num2str(i), 'data folder!'];
        waitbar(1,h1,str2);
        pause(1);
        delete(h1);

        waitbar(i/(length(path)-1),h0,'Reading the next data folder...');
        pause(1)

    end

    % 进度条
    waitbar(1,h0,'Finish all data folders!');
    pause(1);
    delete(h0);
    
    
end















%----------------------------------------------------------------------------------------------------------------------------------------------------%
% 8bit dcm和 8bit自动分割的label的存储
%----------------------------------------------------------------------------------------------------------------------------------------------------%


if((get(handles.Auto_label,'value')== 1) && (get(handles.dcmbit,'value')== 1))

    % 目录集合
    str_origin_data = (strcat(datainput_folder,'\data\'));
    str_origin_label = (strcat(datainput_folder,'\label\'));
    str_target_dcm = (strcat(dataoutput_folder,'\dcm\'));


    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % label文件的dcm存储
    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % 建立文件夹
    mkdir(strcat(dataoutput_folder,'\dcm'));
    mkdir(strcat(str_target_dcm,'label_dcm')); %存储label二值图片


    %进度条
    str = ({'Please waiting to scan the images in label folders...';'Please restart it if the bar does not move for a long time！'});
    h0 = waitbar(0,str);
    pause(2);


    p = genpath(str_origin_label);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path = {}; 
    temp = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp = [temp p(i)];
        else 
            %temp = [temp ':' '\']; 
            path = [temp '\' ; path]; % 加一个斜杠换到下一行
            temp = [];
        end
    end  

    d = dir(str_origin_label); 
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
    num = length(nameFolds);
    

    for i=1:(length(path)-1)
        dirOutput=dir(fullfile(path{i},(strcat('*.',label_type{get(handles.label_type,'Value')})))); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
        fileNames={dirOutput.name}'; % 列向量
        mkdir(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）

        
        %进度条
        str0=['Reading the num ', num2str(i), 'folder in label folders...'];
        h1 = waitbar(0,str0);
        
        
        for p=1:length(fileNames)
            I=imread(strcat(path{i},fileNames{p}));
            
            % 写入文件
            fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀 
            dicomwrite(I, strcat(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')));
            
            % 进度条
            str1=['Gotten the ROIs by ',num2str(p),'images in ',num2str(i), 'label folders...' ]; 
            waitbar(p/(length(fileNames)),h1,str1);
        end
        
        % 进度条
        str2=['Finish num ',num2str(i), 'label folder!'];
        waitbar(1,h1,str2);
        pause(1);
        delete(h1);

        waitbar(i/(length(path)-1),h0,'Reading the next label folder...');
        pause(1)


    end 
    waitbar(1,h0,'Finish all label folders!');
    pause(1);
    delete(h0);
    
    
   
    %----------------------------------------------------------------------------------------------------------------------------------------------------%
    % data文件的dcm存储
    %----------------------------------------------------------------------------------------------------------------------------------------------------%

    % 建立文件夹
    mkdir(strcat(str_target_dcm,'data_dcm')); %存储label二值图片

    %进度条
    str = ({'Please waiting to scan the images in data folders...';'Please restart it if the bar does not move for a long time！'});
    h0 = waitbar(0,str);
    pause(2);


    p = genpath(str_origin_data);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path = {}; 
    temp = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp = [temp p(i)];
        else 
            %temp = [temp ':' '\']; 
            path = [temp '\' ; path]; % 加一个斜杠换到下一行
            temp = [];
        end
    end  

    d = dir(str_origin_data); 
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
    num = length(nameFolds);


    for i=1:(length(path)-1)
        dirOutput=dir(fullfile(path{i},(strcat('*.',data_type{get(handles.data_type,'Value')})))); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
        fileNames={dirOutput.name}'; % 列向量
        mkdir(strcat(str_target_dcm,'data_dcm\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）

        %进度条
        str0=['Reading the num ', num2str(i), 'folder in data folders...'];
        h1 = waitbar(0,str0);
        
        for p=1:length(fileNames)
            I=imread(strcat(path{i},fileNames{p}));

            img = rgb2gray(I); % RGB-Gray8

            % 将bmp文件转为可用的灰度dcm文件
            fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀     
            dicomwrite(img, strcat(strcat(str_target_dcm,'data_dcm\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,'.dcm')));

            % 进度条
            str1=['Gotten image num ',num2str(p),' in ',num2str(i), 'data folders...' ]; 
            waitbar(p/(length(fileNames)),h1,str1);

        end

        % 进度条
        str2=['Finish num ',num2str(i), 'data folder!'];
        waitbar(1,h1,str2);
        pause(1);
        delete(h1);

        waitbar(i/(length(path)-1),h0,'Reading the next data folder...');
        pause(1)

    end

    % 进度条
    waitbar(1,h0,'Finish all data folders!');
    pause(1);
    delete(h0);
       
end




%----------------------------------------------------------------------------------------------------------------------------------------------------%
% 构建4D矩阵：多张dcm转为单张dcm
%----------------------------------------------------------------------------------------------------------------------------------------------------%

if(get(handles.Multiple2single,'value')== 1)
    
    % 读取文件夹内容    
    str_origin_data = (strcat(dataoutput_folder,'\dcm\data_dcm\'));
    str_origin_label = (strcat(dataoutput_folder,'\dcm\label_dcm\'));
    str_target_data = (strcat(dataoutput_folder,'\mul2sig_dcm\data_dcm\'));
    str_target_label = (strcat(dataoutput_folder,'\mul2sig_dcm\label_dcm\'));
    
    % 建立文件夹
    mkdir(strcat(dataoutput_folder,'\mul2sig_dcm'));
    mkdir(strcat(dataoutput_folder,'\mul2sig_dcm\', 'data_dcm'));
    mkdir(strcat(dataoutput_folder,'\mul2sig_dcm\', 'label_dcm'));
   
    
    %进度条
%     str = ({'请稍等正在执行Multiple2single dcm files...';'若进度条无反应请关闭程序并打开主页面说明！'});
    str = ({'Please waiting to start Multiple2single_dcmfiles...';'Please restart it if the bar does not move for a long time！'});
    h0 = waitbar(0,str);
    pause(2);
    
    
    % 主程序运行
    p = genpath(str_origin_data);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path_data = {}; 
    temp_data = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp_data = [temp_data p(i)];
        else 
            %temp = [temp ':' '\']; 
            path_data = [temp_data '\' ; path_data]; % 加一个斜杠换到下一行
            temp_data = [];
        end
    end  


    p = genpath(str_origin_label);% genpath()指产生该目录下的所有文件夹
    length_p = size(p,2); % 长度指所有地址的字符共有多少
    path_label = {}; 
    temp_label = [];
    for i = 1:length_p 
        if p(i) ~= ';' % 分号
            temp_label = [temp_label p(i)];
        else 
            %temp = [temp ':' '\']; 
            path_label = [temp_label '\' ; path_label]; % 加一个斜杠换到下一行
            temp_label = [];
        end
    end  



    d = dir(str_origin_data); 
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。


    for i=1:(length(path_data)-1)

        dirOutput_data=dir(fullfile(path_data{i},'*.dcm')); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
        fileNames_data={dirOutput_data.name}'; % 列向量
        fileNames_data = sort_nat(fileNames_data); % 自然顺序读取文件

        dirOutput_label=dir(fullfile(path_label{i},'*.dcm')); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
        fileNames_label={dirOutput_label.name}'; % 列向量
        fileNames_label = sort_nat(fileNames_label); % 自然顺序读取文件


        %初始化4-D矩阵
        metadata_data=dicominfo(strcat(path_data{i},fileNames_data{1}));
        metadata_label=dicominfo(strcat(path_label{i},fileNames_label{1}));

        %设定每个患者的单帧dcm文件框图数量
        nFrameOut = length(fileNames_data);  
        mov_data=nan(metadata_data.Rows,metadata_data.Columns,1,nFrameOut);
        mov_label=nan(metadata_label.Rows,metadata_label.Columns,1,nFrameOut);

        
        %进度条
        str0=['Reading the num ', num2str(i), 'folder in data&label folders...'];
        h1 = waitbar(0,str0);
        

        for p=1:length(fileNames_data)

            % 将data文件夹数据多帧dcm文件转为单帧dcm文件
            I_data=dicomread(strcat(path_data{i},fileNames_data{p}));
            mov_data(:,:,1,p) = I_data;


            % 将label文件夹数据多帧dcm文件转为单帧dcm文件
            I_label=dicomread(strcat(path_label{i},fileNames_label{p}));
            mov_label(:,:,1,p) = I_label;         
            
            % 进度条
%             str1=['正在同步转换第',num2str(i),'个data&label文件夹中的第',num2str(p),'张图片']; 
            str1=['Converting the num ',num2str(i),'lable and data files in num ', num2str(i), 'folder...'];
            waitbar(p/(length(fileNames)),h1,str1);

        end

        % data写成多帧dicom
        metadata_data.NumberOfFrames=nFrameOut;
        dicomwrite(uint16(mov_data), strcat(strcat(str_target_data,nameFolds{length(nameFolds)+1-i},'_', 'data','.dcm')),metadata_data,'MultiframeSingleFile',true, 'CreateMode','copy');

        % label写成多帧dicom
        metadata_label.NumberOfFrames=nFrameOut;
        dicomwrite(uint8(mov_label), strcat(strcat(str_target_label,nameFolds{length(nameFolds)+1-i},'_','label','.dcm')),metadata_label,'MultiframeSingleFile',true);

        
        % 进度条
%         str2=['第',num2str(i),'个data&label文件夹图片已转换完成'];
%         waitbar(1,h1,str2);
%         pause(0.5);
%         delete(h1);
% 
%         waitbar(i/(length(path)-1),h0,'正在读取下一个data&label文件夹图片...');
%         pause(0.5)
        
        str2=['Finish num ',num2str(i), 'data&label folder!'];
        waitbar(1,h1,str2);
        pause(0.5);
        delete(h1);

        waitbar(i/(length(path)-1),h0,'Reading the next folder...');
        pause(0.5)
        
           
    end
        
    % 进度条
%     waitbar(1,h0,'Multiple2single dcm files 任务已完成');
    waitbar(1,h0,'Finish Multiple2single_dcmfiles!');
    pause(1);
    delete(h0);    
    
end


% 进度条
str = ({'All works have been done successfully!'; 'Please close me now!'; 'Thanks for using RIAS Image Prepare Tool!'});
h0 = waitbar(100,str);


end
    


% --- Executes on button press in Auto_label.
function Auto_label_Callback(hObject, eventdata, handles)
% hObject    handle to Auto_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Auto_label

end


% --- Executes on button press in dcmbit.
function dcmbit_Callback(hObject, eventdata, handles)
% hObject    handle to dcmbit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dcmbit

% 改变8bit dcm选项
if (get(handles.dcmbit,'value')== 1)
    set(handles.centerwidth,'Enable','off'); 
end


if (get(handles.dcmbit,'value')== 0)
    set(handles.centerwidth,'Enable','on');    
end

% 改变8bit data的类型
if(get(handles.dcmbit,'value')== 0)
    set(handles.data_type,'Enable','off');    
end

if(get(handles.dcmbit,'value')== 1)
    set(handles.data_type,'Enable','on');    
end

end


% --- Executes on button press in centerwidth.
function centerwidth_Callback(hObject, eventdata, handles)
% hObject    handle to centerwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of centerwidth

% 按下可以更改窗宽窗位
if (get(handles.centerwidth,'value')== 1)
    set(handles.center,'Enable','on');
    set(handles.width,'Enable','on')   
end


if (get(handles.centerwidth,'value')== 0)
    set(handles.center,'Enable','off');
    set(handles.width,'Enable','off')      
end


% 改变8bit dcm选项
if (get(handles.centerwidth,'value')== 1)
    set(handles.dcmbit,'Enable','off'); 
end


if (get(handles.centerwidth,'value')== 0)
    set(handles.dcmbit,'Enable','on');    
end

end



function center_Callback(hObject, eventdata, handles)
% hObject    handle to center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of center as text
%        str2double(get(hObject,'String')) returns contents of center as a double
end


% --- Executes during object creation, after setting all properties.
function center_CreateFcn(hObject, eventdata, handles)
% hObject    handle to center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double
end


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in Multiple2single.
function Multiple2single_Callback(hObject, eventdata, handles)
% hObject    handle to Multiple2single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Multiple2single
end


% --- Executes on selection change in label_type.
function label_type_Callback(hObject, eventdata, handles)
% hObject    handle to label_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns label_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from label_type
end


% --- Executes during object creation, after setting all properties.
function label_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to label_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes on selection change in data_type.
function data_type_Callback(hObject, eventdata, handles)
% hObject    handle to data_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns data_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from data_type
end


% --- Executes during object creation, after setting all properties.
function data_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end











%----------------------------------------------------------------------------------------------------------------------------------------------------%
% 迁移学习的image crop
%----------------------------------------------------------------------------------------------------------------------------------------------------%



% --- Executes on button press in running_trans.
function running_trans_Callback(hObject, eventdata, handles)
% hObject    handle to running_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% 初始参量传递
datainput_trans_folder=handles.datainput_trans_folder;
dataoutput_trans_folder=handles.dataoutput_trans_folder;

% 文件类型
% % data_type = cellstr(get(handles.data_type,'String'));
% data_type = get(handles.data_type,'String');
% % label_type = cellstr(get(handles.label_type,'String'));
% label_type = get(handles.label_type,'String');

inputdata_type = cellstr(get(handles.inputdata_trans,'String'));
% data_type{get(handles.data_type,'Value')};

outputdata_type = cellstr(get(handles.outputdata_trans,'String'));
% label_type{get(handles.label_type,'Value')};




% 目录集合
str_origin_data = (strcat(datainput_trans_folder,'\data\'));
str_origin_label = (strcat(datainput_trans_folder,'\label\'));
str_target_data = (strcat(dataoutput_trans_folder,'\ouputdata\'));
% str_target_dcm = (strcat(dataoutput_trans_folder,'\dcm\'));


% 建立文件夹
mkdir(strcat(dataoutput_trans_folder,'\ouputdata'));
% mkdir(strcat(dataoutput_folder,'\dcm'));
% mkdir(strcat(str_target_bmp,'label_bmp')); %存储label二值图片
% mkdir(strcat(str_target_dcm,'label_dcm')); %存储label二值图片



%进度条
str = ({'Please waiting to scan images in folders...';'Please restart it if the bar does not move for a long time！'});
h0 = waitbar(0,str);
pause(2);



%data的文件读取
p = genpath(str_origin_data);% genpath()指产生该目录下的所有文件夹
length_p = size(p,2); % 长度指所有地址的字符共有多少
path_data = {}; 
temp = [];
for i = 1:length_p 
    if p(i) ~= ';' % 分号
        temp = [temp p(i)];
    else 
        %temp = [temp ':' '\']; 
        path_data = [temp '\' ; path_data]; % 加一个斜杠换到下一行
        temp = [];
    end
end  

d = dir(str_origin_data); 
isub = [d(:).isdir];
nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
num = length(nameFolds);





% label的文件读取
p = genpath(str_origin_label);% genpath()指产生该目录下的所有文件夹
length_p = size(p,2); % 长度指所有地址的字符共有多少
path = {}; 
temp = [];
for i = 1:length_p 
    if p(i) ~= ';' % 分号
        temp = [temp p(i)];
    else 
        %temp = [temp ':' '\']; 
        path = [temp '\' ; path]; % 加一个斜杠换到下一行
        temp = [];
    end
end  

d = dir(str_origin_label); 
isub = [d(:).isdir];
nameFolds = {d(isub).name}'; % 读取文件夹名，真正的文件夹名从nameFolds{3}开始。
num = length(nameFolds);




for i=1:(length(path)-1)
    %data
    dirOutput=dir(fullfile(path_data{i},(strcat('*.',inputdata_type{get(handles.inputdata_trans,'Value')})))); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
    fileNames_data ={dirOutput.name}'; % 列向量
    
    
    % label
    dirOutput=dir(fullfile(path{i},(strcat('*.',inputdata_type{get(handles.inputdata_trans,'Value')})))); % dir()读取此文件夹下的文件名,f = fullfile('dir1', 'dir2', ..., 'filename')%fullfile构成地址字符串；如：输入：f= fullfile('C:','Applications','matlab','fun.m')得到：f =C:\Applications\matlab\fun.m
    fileNames_label={dirOutput.name}'; % 列向量
%     mkdir(strcat(str_target_dcm,'label_dcm\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）


    %进度条
    str0=['Reading the num ', num2str(i), 'folder in label folders...'];   %str0=['第',num2str(i),'个文件夹图片转化中...'];
    h1 = waitbar(0,str0);

    for p=1:length(fileNames_label)
        
        %初始化计数变量
        label_num = 0;
        
        I_data = imread(strcat(path_data{i},fileNames_data{p}));
        I_label = imread(strcat(path{i},fileNames_label{p}));
        
        % 判断label文件中是否含有二值信息
        [height,width]=size(I_label); %height行，width列
        %边界上坐标
        for a=1:height
            for b=1:width
                if I_label(a,b)==1
                    label_num = label_num + 1;
                end
            end   
        end
        
        if label_num < 4
            continue;
        end
        
        
        % 注意：这里指的是从设定点开始向外扩展的长度，而不是图像边长总长度。
        x_length_set = str2double(get(handles.x_length,'String'));
        y_length_set = str2double(get(handles.y_length,'String'));

        
        
        % 选择模式裁剪
        % 模式一：放大最小矩形法
        if get(handles.max_min_rectangle,'Value')==1
            
            [r,c]=find(I_label==1);
            % 'a'是按面积算的最小矩形，如果按边长用'p'
            [rectx,recty,area,perimeter] = minboundrect(c,r,'a'); 


            % 裁剪采集坐标imcrop()
            x_min = rectx(4,1);
            y_min = recty(1,1);
            x_length = rectx(2,1) - x_min;
            y_length = recty(3,1) - y_min;

            
            % 更新扩展边长后的坐标值
            if(x_min > x_length_set)
                x_min = x_min - x_length_set;    
            end

            if(x_min < x_length_set)
                x_min = 0;
            end

            if(y_min > y_length_set)
               y_min = y_min - y_length_set;
            end

            if(y_min < y_length_set)
                y_min = 0;
            end

            x_length = x_length + 2 * x_length_set;
            y_length = y_length + 2 * y_length_set;

            % 裁剪图像
            I = imcrop(I_data,[x_min, y_min, x_length, y_length]);
            
            fileName_new = fileNames{p}(1:end-4); % 只提取文件名字而不包含后缀
            mkdir(strcat(str_target_data,'max_min_rectangle'));
            mkdir(strcat(str_target_data,'max_min_rectangle\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）
            imwrite(I, strcat(strcat(str_target_data,'max_min_rectangle\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,(strcat('.',outputdata_type{get(handles.outputdata_trans,'Value')})))));
            
        end
        
        
        
        
        % 模式二：最小矩形旋转法
        if get(handles.min_rectangle_rotate,'Value')==1

            [r,c]=find(I_label==1);
            % 'a'是按面积算的最小矩形，如果按边长用'p'
            [rectx,recty,area,perimeter] = minboundrect(c,r,'a'); 

            % 计算旋转角度之前的距离
            y_temp = recty(2,1) - recty(1,1);
            x_temp = rectx(2,1) - rectx(1,1);

            % 旋转图片
            x=atan(y_temp/x_temp);
            x=x*180/pi;
            I_end = imrotate(I_label,x,'loose');
            I_data_temp = imrotate(I_data,x,'loose');
            
      
            [r,c]=find(I_end==1);
            % 'a'是按面积算的最小矩形，如果按边长用'p'
            [rectx,recty,area,perimeter] = minboundrect(c,r,'a'); 
            % imshow(bw);hold on
            line(rectx,recty);

            % 裁剪采集坐标imcrop()
            x_min = rectx(4,1);
            y_min = recty(1,1);
            x_length = rectx(2,1) - x_min;
            y_length = recty(3,1) - y_min;


            % 更新扩展边长后的坐标值
            if(x_min > x_length_set)
                x_min = x_min - x_length_set;    
            end

            if(x_min < x_length_set)
                x_min = 0;
            end

            if(y_min > y_length_set)
               y_min = y_min - y_length_set;
            end

            if(y_min < y_length_set)
                y_min = 0;
            end

            x_length = x_length + 2 * x_length_set;
            y_length = y_length + 2 * y_length_set;


            I = imcrop(I_data_temp,[x_min, y_min, x_length, y_length]);
            
            fileName_new = fileNames_data{p}(1:end-4); % 只提取文件名字而不包含后缀
            mkdir(strcat(str_target_data,'min_rectangle_rotate'));
            mkdir(strcat(str_target_data,'min_rectangle_rotate\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）
            imwrite(I, strcat(strcat(str_target_data,'min_rectangle_rotate\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,(strcat('.',outputdata_type{get(handles.outputdata_trans,'Value')})))));
                       
        end
        
        
        
        
        % 模式三：质心定尺寸法
        if get(handles.centroid_length,'Value')==1                
            
            [L,num]=bwlabel(I_label,8);     %标注二进制图像中已连接的部分
%             plot_x=zeros(1,1);         %用于记录质心位置的坐标
%             plot_y=zeros(1,1);

            % 求质心
            sum_x=0;sum_y=0;area=0;
            [height,width]=size(I_label);
            for i_center=1:height
                for j_center=1:width
                    if L(i_center,j_center)==1
                        sum_x=sum_x+i_center;
                        sum_y=sum_y+j_center;
                        area=area+1;
                    end
                end
            end
            % 质心坐标
            plot_x = fix(sum_x/area);
            plot_y = fix(sum_y/area);

            % 裁剪图像
            x_min = plot_y - y_length_set/2;
            y_min = plot_x - x_length_set/2;
 
            I = imcrop(I_data,[x_min, y_min, x_length_set, y_length_set]);
            fileName_new = fileNames_data{p}(1:end-4); % 只提取文件名字而不包含后缀
            mkdir(strcat(str_target_data,'centroid_length'));
            mkdir(strcat(str_target_data,'centroid_length\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）
            imwrite(I, strcat(strcat(str_target_data,'centroid_length\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,(strcat('.',outputdata_type{get(handles.outputdata_trans,'Value')})))));          
            
        end
        
        
        
        
        % 模式四：最外侧轮廓坐标法
        if get(handles.outline_length,'Value')==1
            
            [L,num]=bwlabel(I_label,4);     %标注二进制图像中已连接的部分
            [height,width]=size(I_label); %height行，width列。

            %边界上坐标
            for a=1:height
                for b=1:width
                    if L(a,b)==1
                        x_up = b;
                        y_up = a;
                        break
                    end
                end

                if L(a,b)==1
                    break
                end    
            end


            %边界左坐标
            for a=1:width
                for b=1:height
                    if L(b,a)==1
                        x_left = a;
                        y_left = b;
                        break
                    end
                end

                if L(b,a)==1
                    break
                end    
            end


            %边界下坐标
            for a=height:-1:1
                for b=1:width
                    if L(a,b)==1
                        x_down = b;
                        y_down = a;
                        break
                    end
                end

                if L(a,b)==1
                    break
                end    
            end


            %边界右坐标
            for a=width:-1:1
                for b=1:height
                    if L(b,a)==1
                        x_right = a;
                        y_right = b;
                        break
                    end
                end

                if L(b,a)==1
                    break
                end    
            end

            
            x_min = x_left;
            y_min = y_up;
            
            % 更新扩展边长后的坐标值
            if(x_min > x_length_set)
                x_min = x_min - x_length_set;    
            end

            if(x_min < x_length_set)
                x_min = 0;
            end

            if(y_min > y_length_set)
               y_min = y_min - y_length_set;
            end

            if(y_min < y_length_set)
                y_min = 0;
            end
            
            x_length = x_right - x_left;
            y_length = y_down - y_up;

            x_length = x_length + 2 * x_length_set;
            y_length = y_length + 2 * y_length_set;


            I = imcrop(I_data,[x_min, y_min, x_length, y_length]);
            fileName_new = fileNames_data{p}(1:end-4); % 只提取文件名字而不包含后缀
            mkdir(strcat(str_target_data,'outline_length'));
            mkdir(strcat(str_target_data,'outline_length\',nameFolds{length(nameFolds)+1-i})); % 在原文件夹下新建患者姓名文件夹（文件夹顺序反过来）
            imwrite(I, strcat(strcat(str_target_data,'outline_length\',nameFolds{length(nameFolds)+1-i},'\',fileName_new,(strcat('.',outputdata_type{get(handles.outputdata_trans,'Value')})))));               
            
            
        end    

       
            
        % 进度条
        str1=['Gropping images by ',num2str(p),'images in ',num2str(i), 'data folders...' ]; 
        waitbar(p/(length(fileNames_data)),h1,str1);

    end
    

    % 进度条
    str2=['Finish the ',num2str(i), 'data folder!'];
    waitbar(1,h1,str2);
    pause(1);
    delete(h1);

    waitbar(i/(length(path)-1),h0,'Reading the next data folder...');
    pause(1)

end
%     waitbar(1,h0,'所有label文件识别已完成');
waitbar(1,h0,'Finish all cropping images!');
pause(1);
delete(h0);


% 进度条
str = ({'All works have been done successfully!'; 'Please close me now!'; 'Thanks for using RIAS Image Prepare Tool!'});
h0 = waitbar(100,str);

end








% --- Executes on button press in data_input_trans.
function data_input_trans_Callback(hObject, eventdata, handles)
% hObject    handle to data_input_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%获取文件夹
datainput_trans_folder = uigetdir;

handles.datainput_trans_folder = datainput_trans_folder;
guidata(hObject,handles);  %更新handles里面每一个元素

set(handles.data_output_trans,'Enable','on');

end



% --- Executes on button press in data_output_trans.
function data_output_trans_Callback(hObject, eventdata, handles)
% hObject    handle to data_output_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%获取文件夹
dataoutput_trans_folder = uigetdir;

handles.dataoutput_trans_folder = dataoutput_trans_folder;
guidata(hObject,handles);

set(handles.running_trans,'Enable','on');

end





% --- Executes on button press in min_rectangle_rotate.
function min_rectangle_rotate_Callback(hObject, eventdata, handles)
% hObject    handle to min_rectangle_rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of min_rectangle_rotate
end


% --- Executes on button press in max_min_rectangle.
function max_min_rectangle_Callback(hObject, eventdata, handles)
% hObject    handle to max_min_rectangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of max_min_rectangle
end


% --- Executes on button press in outline_length.
function outline_length_Callback(hObject, eventdata, handles)
% hObject    handle to outline_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outline_length
end


% --- Executes on button press in centroid_length.
function centroid_length_Callback(hObject, eventdata, handles)
% hObject    handle to centroid_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of centroid_length
end




function x_length_Callback(hObject, eventdata, handles)
% hObject    handle to x_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_length as text
%        str2double(get(hObject,'String')) returns contents of x_length as a double
end


% --- Executes during object creation, after setting all properties.
function x_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function y_length_Callback(hObject, eventdata, handles)
% hObject    handle to y_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_length as text
%        str2double(get(hObject,'String')) returns contents of y_length as a double
end


% --- Executes during object creation, after setting all properties.
function y_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in outputdata_trans.
function outputdata_trans_Callback(hObject, eventdata, handles)
% hObject    handle to outputdata_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns outputdata_trans contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outputdata_trans
end


% --- Executes during object creation, after setting all properties.
function outputdata_trans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputdata_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in inputdata_trans.
function inputdata_trans_Callback(hObject, eventdata, handles)
% hObject    handle to inputdata_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns inputdata_trans contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputdata_trans
end


% --- Executes during object creation, after setting all properties.
function inputdata_trans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputdata_trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
