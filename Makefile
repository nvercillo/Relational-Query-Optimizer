SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
DATA_DIR=data

SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)
EXECUTABLE = $(BIN_DIR)/main


INPUT_FILE = $(DATA_DIR)/input$(FILE_SUFFIX).txt
OUTPUT_FILE = $(DATA_DIR)/output$(FILE_SUFFIX).json
 
all: create_folders $(EXECUTABLE)  

create_folders: 
	mkdir $(SRC_DIR) | echo "Folder already exists"
	mkdir $(OBJ_DIR)  | echo "Folder already exists"
	mkdir $(BIN_DIR)  | echo "Folder already exists"

$(EXECUTABLE): $(OBJECTS)
	g++ $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	g++ -std=c++11 -c $< -o $@ -Wno-c++11-extensions

clean:
	rm -f $(OBJ_DIR)/*.o $(EXECUTABLE)

run: all 

	echo "\n\n\nRUNNING PROGRAM :)"
	./$(EXECUTABLE) $(INPUT_FILE) $(OUTPUT_FILE)


full: clean all
	
	echo "\n\n\nRUNNING PROGRAM :)"
	./$(EXECUTABLE) $(INPUT_FILE) $(OUTPUT_FILE)

debug: CXXFLAGS += -g
debug: all
	gdb $(EXECUTABLE) $(INPUT_FILE) $(OUTPUT_FILE)
.PHONY: all clean
