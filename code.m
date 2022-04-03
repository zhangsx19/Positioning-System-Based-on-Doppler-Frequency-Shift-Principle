clc;close all;clear;
[y,fs] = audioread("sound.wav");
n = length(y);%采样点数
y1=fft(y,n);
yfft = abs(fftshift(y1));
freq2 = (0:n-1)*fs/n-fs/2;%将横坐标转化，显示为频率f
figure;subplot(2,3,1);
plot(freq2,yfft,'k');xlabel('Frequency/Hz'); ylabel('Amplitude');
title('fft');%频谱图

%时频变化图(高频率分辨率求最大最小频率)
wlen1 = 1024;%设置窗口长度。窗口越长时间分辨率越差，频率分辨率越好。反之时间分辨率好，频率分辨率差。
wstep1 = 1;%每次平移的步长，最小为1。越小图像时间精度越好，但计算量大。
nfft1 = wlen1;%短时傅里叶变换点数
%figure;spectrogram(y,wlen,wlen-wstep,nfft,fs,'yaxis');title("短时傅里叶");%直接作图
[S1,F1,T1,P1] = spectrogram(y,wlen1,wlen1-wstep1,nfft1,fs,'yaxis');
%计算最大最小频率
[max_P1, index_P1] = max(P1);%每个时间点功率最大值对应的频率
freq1 = F1(index_P1);
[fmax1,t_fmax1] = max(freq1); 
[fmin1,t_fmin1] = min(freq1);
v = 340;%声速
vs = (fmax1-fmin1)*v/(fmax1+fmin1);%求扬声器的运动速率vs
f0 = 2*fmax1*fmin1/(fmax1+fmin1);%求发射频率f0
%画图
subplot(2,3,2);imagesc(T1,F1,10*log10(P1));title('短时傅里叶变换高频率分辨率');
xlabel('time/s'); ylabel('Frequency/Hz');h=colorbar;
h.Label.String = 'Power/Frequency(dB/Hz)';
subplot(2,3,3);plot(T1,freq1);xlabel('time/s'); ylabel('Frequency/Hz');title("频率时间曲线");

%时频变化图(高频率分辨率求周期和t_fmax-t_fmin)
wlen2 = 256;%设置窗口长度。窗口越长时间分辨率越差，频率分辨率越好。反之时间分辨率好，频率分辨率差。
wstep2 = 1;%每次平移的步长，最小为1。越小图像时间精度越好，但计算量大。
nfft2 = wlen2;%短时傅里叶变换点数
[S2,F2,T2,P2] = spectrogram(y,wlen2,wlen2-wstep2,nfft2,fs,'yaxis');
[max_P2, index_P2] = max(P2);%每个时间点功率最大值对应的频率
freq2 = F2(index_P2);
%计算周期和t_fmax-t_fmin
[fmax2,t_fmax2] = max(freq2); %最大频率对应的第一个时间点
[fmin2,t_fmin2] = min(freq2); %最小频率对应的第一个时间点
deltaT = abs(T2(t_fmax2)-T2(t_fmin2));
T_fmax2 = T2(freq2==fmax2);%找出最大频率对应的所有时间点，由频率时间曲线可知有5个周期
T_fmax2_1 = find(T_fmax2<1);
T_fmax2_2 = find(T_fmax2>4);
T = (T_fmax2(T_fmax2_2(1))-T_fmax2(T_fmax2_1(1)))/5;%平均值法求周期
r = vs*T/2/pi;%求得半径
w = vs/r;%求得角速度
d = r/cos(w*deltaT/2);
%画图
subplot(2,3,4);imagesc(T2,F2,10*log10(P2));title('短时傅里叶变换高时间分辨率');
xlabel('time/s'); ylabel('Frequency/Hz');h=colorbar;
h.Label.String = 'Power/Frequency(dB/Hz)';
subplot(2,3,5);plot(T2,freq2);xlabel('time/s'); ylabel('Frequency/Hz');title("频率时间曲线");

%相位图
subplot(2,3,6);imagesc(T1,F1,angle(S1));title('相位图');
xlabel('time/s'); ylabel('Frequency/Hz');h=colorbar;%提取相位
theta = abs(angle(S1(index_P1(t_fmax1),t_fmax1))-angle(S1(index_P1(t_fmin1),t_fmin1)))/2;


