function [event_st, HDR] = read_bdf_marker_chans(bdfFileName)
% Reads events from Status channel in BDF file header and returns an EEGLAB
% type event structure and biosig-type HDR structure. Note, the HDR
% structure is incomplete because only parts of sopen were used. Thus, one
% should really only consult HDR.EVENT
%
% [event_st, HDR] = read_bdf_marker_chans(bdfFileName);
%
% Much of the code borrowed from biosig toolbox sopen() and
% bdf2biosig_events() functions.

% 04Jul2012 Petr Janata

if ~exist(bdfFileName,'file')
	error('Could not locate file: %s', bdfFileName)
end

%%%%% Define Valid Data types %%%%%%
%GDFTYPES=[0 1 2 3 4 5 6 7 16 17 255+(1:64) 511+(1:64)];
GDFTYPES=[0 1 2 3 4 5 6 7 16 17 18 255+[1 12 22 24] 511+[1 12 22 24]];

%%%%% Define Size for each data type %%%%%
GDFTYP_BYTE=zeros(1,512+64);
GDFTYP_BYTE(256+(1:64))=(1:64)/8;
GDFTYP_BYTE(512+(1:64))=(1:64)/8;
GDFTYP_BYTE(1:19)=[1 1 1 2 2 4 4 8 8 4 8 0 0 0 0 0 4 8 16]';

HDR.FileName = bdfFileName;
HDR.FILE.stdout = 1;
HDR.FILE.stderr = 2;
HDR.FILE.PERMISSION='r';

% Read in Header information
HDR = getfiletype(HDR);
[HDR.FILE.FID]=fopen(HDR.FileName,[HDR.FILE.PERMISSION,'b'],'ieee-le');
                

%%% Read Fixed Header %%%
[H1,count]=fread(HDR.FILE.FID,[1,192],'uint8');     %
if count<192,
	HDR.ErrNo = [64,HDR.ErrNo];
	return;
end;
H1(193:256)= fread(HDR.FILE.FID,[1,256-192],'uint8');     %
H1 = char(H1);

H2idx = [16 80 8 8 8 8 8 80 8 32];

HDR.VERSION=char(H1(1:8));                     % 8 Byte  Versionsnummer
if all(abs(H1(1:8))==[255,abs('BIOSEMI')]),
	HDR.VERSION = -1;
end

HDR.HeadLen = str2double(H1(185:192));           % 8 Bytes  Length of Header
HDR.reserved1=H1(193:236);              % 44 Bytes reserved
HDR.NRec    = str2double(H1(237:244));     % 8 Bytes  # of data records
HDR.Dur     = str2double(H1(245:252));     % 8 Bytes  # duration of data record in sec
HDR.NS      = str2double(H1(253:256));     % 4 Bytes  # of signals
HDR.AS.H1 = H1;	                     % for debugging the EDF Header

idx1=cumsum([0 H2idx]);
idx2=HDR.NS*idx1;

h2=zeros(HDR.NS,256);
[H2,count]=fread(HDR.FILE.FID,HDR.NS*256,'uint8');
if count < HDR.NS*256
	%HDR.ErrNo=[8,HDR.ErrNo];
	return;
end;

%tmp=find((H2<32) | (H2>126)); % would confirm
tmp = find((H2<32) | ((H2>126) & (H2~=255) & (H2~=181)& (H2~=230)));
if ~isempty(tmp) %%%%% not EDF because filled out with ASCII(0) - should be spaces
	H2(tmp) = 32;
	HDR.ErrNo = [1026,HDR.ErrNo];
end;

for k=1:length(H2idx);
	%disp([k size(H2) idx2(k) idx2(k+1) H2idx(k)]);
	h2(:,idx1(k)+1:idx1(k+1))=reshape(H2(idx2(k)+1:idx2(k+1)),H2idx(k),HDR.NS)';
end;

h2=char(h2);

HDR.Label      =            h2(:,idx1(1)+1:idx1(2));
HDR.Transducer =    cellstr(h2(:,idx1(2)+1:idx1(3)));
HDR.PhysDim    =            h2(:,idx1(3)+1:idx1(4));
HDR.PhysMin    = str2double(h2(:,idx1(4)+1:idx1(5)))';
HDR.PhysMax    = str2double(h2(:,idx1(5)+1:idx1(6)))';
HDR.DigMin     = str2double(h2(:,idx1(6)+1:idx1(7)))';
HDR.DigMax     = str2double(h2(:,idx1(7)+1:idx1(8)))';
HDR.PreFilt    =            h2(:,idx1(8)+1:idx1(9));
HDR.AS.SPR     = str2double(h2(:,idx1(9)+1:idx1(10)));

if (HDR.VERSION ~= -1),
	HDR.GDFTYP     = 3*ones(1,HDR.NS);	%	datatype
else
	HDR.GDFTYP     = (255+24)*ones(1,HDR.NS);	%	datatype
end;

HDR.AS.spb = sum(HDR.AS.SPR);	% Samples per Block
HDR.AS.bi  = [0;cumsum(HDR.AS.SPR(:))];
HDR.AS.bpb = sum(ceil(HDR.AS.SPR.*GDFTYP_BYTE(HDR.GDFTYP+1)'));	% Bytes per Block

HDR.EVENT.POS = [];
HDR.EVENT.TYP = [];

tmp = strmatch('Status',HDR.Label);
HDR.BDF.Status.Channel = tmp;

% Move to the beginning of the Status block
status = fseek(HDR.FILE.FID,HDR.HeadLen+HDR.AS.bi(HDR.BDF.Status.Channel)*3,'bof');

% Read in the Status information.  We are dealing with 24 bits per event,
% so read in a groups of 3 unsigned 8 bit integers
[t,c] = fread(HDR.FILE.FID,inf,[int2str(HDR.AS.SPR(HDR.BDF.Status.Channel)*3),'*uint8'],HDR.AS.bpb-HDR.AS.SPR(HDR.BDF.Status.Channel)*3);

% Close the file
fclose(HDR.FILE.FID);

% Convert into 24 bit number
HDR.BDF.ANNONS = reshape(double(t),3,length(t)/3)'*2.^[0;8;16];

t = HDR.BDF.ANNONS; % these values are always high and go low when an event occurs
eventVector = bitand(t, hex2dec('00ffff'));

%% Only inspect bits 9-16
% Because marker events are occuring on discrete lines the problem of
% identifying event onsets is simplified because we only need to look at
% state transitions on one line at a time
bitOffset = 8;
eventVector = bitshift(eventVector,-bitOffset);

nbits = 8;
for ibit = 1:nbits
	onsetMask = diff([0; ~bitget(eventVector,ibit)]) > 0;
	if any(onsetMask)
		fprintf('Found %d events on bit %d\n', sum(onsetMask), ibit+bitOffset);
		HDR.EVENT.POS = [HDR.EVENT.POS; find(onsetMask)];
		HDR.EVENT.TYP = [HDR.EVENT.TYP; repmat(2^(ibit+bitOffset-1),sum(onsetMask),1)];
	end
end

% Sort the events
[HDR.EVENT.POS, idx] = sort(HDR.EVENT.POS, 'ascend');
HDR.EVENT.TYP = HDR.EVENT.TYP(idx);

% Create EEGLAB event structure
event_st = struct('type',[],'latency',[],'duration',[]);
for iev = 1:length(HDR.EVENT.POS)
	event_st(iev).type = HDR.EVENT.TYP(iev);
	event_st(iev).latency = HDR.EVENT.POS(iev);
end
return
