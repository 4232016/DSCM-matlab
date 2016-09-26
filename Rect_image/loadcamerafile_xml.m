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
  while ~isempty(childNode)                    % 遍历FDs的所有子节点，也就是遍历 ("rows, cols, data") 节点  
  
      if childNode.getNodeType == childNode.ELEMENT_NODE ;    % 检查当前节点没有子节点，  childNode.ELEMENT_NODE 定义为没有子节点。  
        childNodeNm = char(childNode.getTagName);        % 当前节点的名字 
        if strcmp(childNodeNm,'rows')
            rows = char(childNode.getFirstChild.getData);
        end
        if strcmp(childNodeNm,'cols')
            cols = char(childNode.getFirstChild.getData);
        end
        if strcmp(childNodeNm,'data')
            Data = char(childNode.getFirstChild.getData);    % 当前节点的内容 
        end
      end            
     childNode = childNode.getNextSibling;     % 切换到下一个节点  
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
  
 

  
  
  
  
  