function  [A] = loadcamerafile(filename)
Pointposition = findstr(filename,'_');
if isempty(Pointposition)
   Pointposition = findstr(filename,'.');
end

f2 = filename(1:Pointposition-1);
xmlDoc = xmlread(filename);
FDsArray = xmlDoc.getElementsByTagName(f2);
thisItem = FDsArray.item(0);
childNode = thisItem.getFirstChild; 
  while ~isempty(childNode)                    % ����FDs�������ӽڵ㣬Ҳ���Ǳ��� ("rows, cols, data") �ڵ�  
  
      if childNode.getNodeType == childNode.ELEMENT_NODE ;    % ��鵱ǰ�ڵ�û���ӽڵ㣬  childNode.ELEMENT_NODE ����Ϊû���ӽڵ㡣  
        childNodeNm = char(childNode.getTagName);        % ��ǰ�ڵ������ 
        if strcmp(childNodeNm,'rows')
            rows = char(childNode.getFirstChild.getData);
        end
        if strcmp(childNodeNm,'cols')
            cols = char(childNode.getFirstChild.getData);
        end
        if strcmp(childNodeNm,'data')
            Data = char(childNode.getFirstChild.getData);    % ��ǰ�ڵ������ 
        end
      end            
     childNode = childNode.getNextSibling;     % �л�����һ���ڵ�  
  end  % End WHILE 

  k = size(Data,2);
  counter = 0;
  str='';
  j =1 ;
  for i=1:k
      if ~isspace(Data(i)) 
          str =strcat(str,Data(i));       
      elseif ~isempty(str)
          str = str2num(str);
          B(j) = {str};
          str = '';
          j = j+1;
      end
  end
      str = str2num(str);
      B(j) = {str};
  
    
  rows = str2num(rows);
  cols = str2num(cols);
  A = double(zeros(rows,cols));
  n = size(B);
  k = 1;
  for i=1:rows
      for j=1:cols
          A(i,j) = B{k}(1,1);
          k = k+1;
      end
  end    
  
 

  
  
  
  
  