function redraw(frame)
global corrected
imshow(corrected(:,:,frame),[min(corrected(:)) max(corrected(:))])
end 