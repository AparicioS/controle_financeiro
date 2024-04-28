
import 'package:flutter/material.dart';

getDropdownMenuProjeto(projetos){
        return projetos.map((doc) => DropdownMenuItem<String>(
                value: doc.id,
                child: Text(doc.nome),
              ))
          .toList();
          
  }